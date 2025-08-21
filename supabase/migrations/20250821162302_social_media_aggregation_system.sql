-- Location: supabase/migrations/20250821162302_social_media_aggregation_system.sql
-- Schema Analysis: Fresh database with no existing schema
-- Integration Type: Complete new schema creation
-- Dependencies: None (fresh project)

-- 1. Custom Types
CREATE TYPE public.platform_type AS ENUM ('instagram', 'tiktok', 'binance', 'news', 'twitter', 'facebook', 'youtube', 'linkedin', 'reddit');
CREATE TYPE public.content_type AS ENUM ('image', 'video', 'text', 'article', 'carousel', 'story');
CREATE TYPE public.connection_status AS ENUM ('connected', 'disconnected', 'pending', 'error');
CREATE TYPE public.user_role AS ENUM ('admin', 'user', 'moderator');

-- 2. Core Tables - User Management
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    username TEXT UNIQUE,
    display_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    role public.user_role DEFAULT 'user'::public.user_role,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Platform Connections
CREATE TABLE public.platform_connections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    platform public.platform_type NOT NULL,
    platform_user_id TEXT,
    platform_username TEXT,
    access_token TEXT,
    refresh_token TEXT,
    connection_status public.connection_status DEFAULT 'pending'::public.connection_status,
    last_sync_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    connection_metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Content Posts
CREATE TABLE public.social_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    platform public.platform_type NOT NULL,
    platform_post_id TEXT NOT NULL,
    content_type public.content_type NOT NULL,
    title TEXT,
    description TEXT,
    content_text TEXT,
    media_urls TEXT[],
    thumbnail_url TEXT,
    external_url TEXT,
    author_name TEXT,
    author_avatar TEXT,
    author_username TEXT,
    engagement_metrics JSONB DEFAULT '{}'::jsonb,
    posted_at TIMESTAMPTZ,
    synced_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    is_visible BOOLEAN DEFAULT true,
    metadata JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. User Interactions
CREATE TABLE public.user_interactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    post_id UUID REFERENCES public.social_posts(id) ON DELETE CASCADE,
    interaction_type TEXT NOT NULL, -- 'like', 'save', 'share', 'hide'
    interaction_data JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Content Categories/Tags
CREATE TABLE public.content_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    color_hex TEXT DEFAULT '#6366f1',
    icon_name TEXT,
    is_system_category BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. Post Categories Junction
CREATE TABLE public.post_categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID REFERENCES public.social_posts(id) ON DELETE CASCADE,
    category_id UUID REFERENCES public.content_categories(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(post_id, category_id)
);

-- 8. Feed Preferences
CREATE TABLE public.feed_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    preferred_platforms public.platform_type[],
    preferred_content_types public.content_type[],
    show_nsfw BOOLEAN DEFAULT false,
    auto_refresh BOOLEAN DEFAULT true,
    posts_per_page INTEGER DEFAULT 20,
    sort_preference TEXT DEFAULT 'chronological', -- 'chronological', 'engagement', 'relevance'
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)
);

-- 9. Essential Indexes
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_username ON public.user_profiles(username);
CREATE INDEX idx_platform_connections_user_id ON public.platform_connections(user_id);
CREATE INDEX idx_platform_connections_platform ON public.platform_connections(platform);
CREATE INDEX idx_social_posts_user_id ON public.social_posts(user_id);
CREATE INDEX idx_social_posts_platform ON public.social_posts(platform);
CREATE INDEX idx_social_posts_posted_at ON public.social_posts(posted_at DESC);
CREATE INDEX idx_social_posts_visible ON public.social_posts(is_visible);
CREATE INDEX idx_user_interactions_user_id ON public.user_interactions(user_id);
CREATE INDEX idx_user_interactions_post_id ON public.user_interactions(post_id);
CREATE INDEX idx_post_categories_post_id ON public.post_categories(post_id);
CREATE INDEX idx_post_categories_category_id ON public.post_categories(category_id);

-- 10. Functions (Created BEFORE RLS policies)
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.user_profiles (id, email, username, display_name)
    VALUES (
        NEW.id,
        NEW.email,
        COALESCE(NEW.raw_user_meta_data->>'username', split_part(NEW.email, '@', 1)),
        COALESCE(NEW.raw_user_meta_data->>'display_name', split_part(NEW.email, '@', 1))
    );
    
    -- Create default feed preferences
    INSERT INTO public.feed_preferences (user_id, preferred_platforms, preferred_content_types)
    VALUES (
        NEW.id,
        ARRAY['instagram', 'tiktok', 'news']::public.platform_type[],
        ARRAY['image', 'video', 'article']::public.content_type[]
    );
    
    RETURN NEW;
END;
$$;

-- 11. Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.platform_connections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.social_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_interactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.content_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.post_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.feed_preferences ENABLE ROW LEVEL SECURITY;

-- 12. RLS Policies (Following Pattern System)
-- Pattern 1: Core user table (user_profiles) - Simple only, no functions
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Pattern 2: Simple user ownership for most tables
CREATE POLICY "users_manage_own_platform_connections"
ON public.platform_connections
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_manage_own_social_posts"
ON public.social_posts
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_manage_own_user_interactions"
ON public.user_interactions
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_manage_own_feed_preferences"
ON public.feed_preferences
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- Pattern 4: Public read, private write for categories
CREATE POLICY "public_can_read_content_categories"
ON public.content_categories
FOR SELECT
TO public
USING (true);

CREATE POLICY "authenticated_users_manage_categories"
ON public.content_categories
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- Pattern 4: Public read for post categories junction
CREATE POLICY "public_can_read_post_categories"
ON public.post_categories
FOR SELECT
TO public
USING (true);

CREATE POLICY "users_manage_post_categories"
ON public.post_categories
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- 13. Triggers
CREATE TRIGGER update_user_profiles_updated_at
    BEFORE UPDATE ON public.user_profiles
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_platform_connections_updated_at
    BEFORE UPDATE ON public.platform_connections
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_social_posts_updated_at
    BEFORE UPDATE ON public.social_posts
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER update_feed_preferences_updated_at
    BEFORE UPDATE ON public.feed_preferences
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 14. Mock Data
DO $$
DECLARE
    user1_auth_id UUID := gen_random_uuid();
    user2_auth_id UUID := gen_random_uuid();
    admin_auth_id UUID := gen_random_uuid();
    category1_id UUID := gen_random_uuid();
    category2_id UUID := gen_random_uuid();
    category3_id UUID := gen_random_uuid();
    post1_id UUID := gen_random_uuid();
    post2_id UUID := gen_random_uuid();
    post3_id UUID := gen_random_uuid();
BEGIN
    -- Create auth users with required fields
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (user1_auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'alex.johnson@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"username": "alexj", "display_name": "Alex Johnson"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user2_auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'sarah.wilson@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"username": "sarahw", "display_name": "Sarah Wilson"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (admin_auth_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@socialai.com', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"username": "admin", "display_name": "Social AI Admin", "role": "admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create categories
    INSERT INTO public.content_categories (id, name, description, color_hex, icon_name, is_system_category) VALUES
        (category1_id, 'Technology', 'Tech news and updates', '#3b82f6', 'cpu', true),
        (category2_id, 'Entertainment', 'Fun and entertainment content', '#f59e0b', 'film', true),
        (category3_id, 'Finance', 'Financial news and crypto updates', '#10b981', 'trending-up', true);

    -- Create platform connections
    INSERT INTO public.platform_connections (user_id, platform, platform_username, connection_status, connection_metadata) VALUES
        (user1_auth_id, 'instagram'::public.platform_type, 'alexj_insta', 'connected'::public.connection_status, '{"followers": 1200, "following": 350}'::jsonb),
        (user1_auth_id, 'tiktok'::public.platform_type, 'alexj_tiktok', 'connected'::public.connection_status, '{"followers": 5600, "following": 120}'::jsonb),
        (user2_auth_id, 'instagram'::public.platform_type, 'sarah_explores', 'connected'::public.connection_status, '{"followers": 890, "following": 445}'::jsonb),
        (user2_auth_id, 'binance'::public.platform_type, 'sarah_crypto', 'connected'::public.connection_status, '{"verified": true}'::jsonb);

    -- Create social posts
    INSERT INTO public.social_posts (
        id, user_id, platform, platform_post_id, content_type, title, description, 
        media_urls, thumbnail_url, external_url, author_name, author_username,
        engagement_metrics, posted_at, is_visible
    ) VALUES
        (post1_id, user1_auth_id, 'instagram'::public.platform_type, 'ig_12345', 'image'::public.content_type,
         'Amazing sunset in Bali', 'Just witnessed the most beautiful sunset at Uluwatu Temple. The colors were absolutely magical! 🌅✨',
         ARRAY['https://images.unsplash.com/photo-1506905925346-21bda4d32df4'], 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=300',
         'https://instagram.com/p/abc123', 'Alex Johnson', 'alexj_insta',
         '{"likes": 245, "comments": 18, "shares": 12}'::jsonb, now() - interval '2 hours', true),
        
        (post2_id, user1_auth_id, 'tiktok'::public.platform_type, 'tt_67890', 'video'::public.content_type,
         'Quick Morning Routine', 'My 5-minute morning routine that changed my life! Who else needs this? 💪',
         ARRAY['https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4'], 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=300',
         'https://tiktok.com/@alexj_tiktok/video/123456789', 'Alex Johnson', 'alexj_tiktok',
         '{"likes": 1250, "comments": 89, "shares": 67, "views": 5600}'::jsonb, now() - interval '4 hours', true),
        
        (post3_id, user2_auth_id, 'binance'::public.platform_type, 'bn_news_001', 'article'::public.content_type,
         'Bitcoin Reaches New All-Time High', 'Bitcoin surges past $70,000 amid institutional adoption and ETF approval rumors. Market analysts predict continued bullish momentum.',
         ARRAY['https://images.unsplash.com/photo-1640340434855-6084b1f4901c'], 'https://images.unsplash.com/photo-1640340434855-6084b1f4901c?w=300',
         'https://binance.com/en/news/bitcoin-ath-analysis', 'Binance News', 'binance_official',
         '{"views": 15600, "likes": 892, "comments": 156}'::jsonb, now() - interval '1 hour', true);

    -- Create post categories
    INSERT INTO public.post_categories (post_id, category_id) VALUES
        (post2_id, category2_id), -- TikTok video -> Entertainment
        (post3_id, category3_id); -- Binance news -> Finance

    -- Create user interactions
    INSERT INTO public.user_interactions (user_id, post_id, interaction_type, interaction_data) VALUES
        (user2_auth_id, post1_id, 'like', '{"timestamp": "2025-08-21T16:20:00Z"}'::jsonb),
        (user2_auth_id, post2_id, 'save', '{"timestamp": "2025-08-21T16:18:00Z"}'::jsonb),
        (user1_auth_id, post3_id, 'like', '{"timestamp": "2025-08-21T16:15:00Z"}'::jsonb);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;