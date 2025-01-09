

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pgsodium" WITH SCHEMA "pgsodium";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."handle_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO ''
    AS $$
begin
  -- Insert a new artist profile for the user
  insert into public.artist_profiles (id, artist_name, artist_image_url, banner_image_url)
  values (
    new.id,
    new.raw_user_meta_data->>'artist_name', 
    new.raw_user_meta_data->>'artist_image_url',
    new.raw_user_meta_data->>'banner_image_url'
  );
  return new;
end;
$$;


ALTER FUNCTION "public"."handle_new_user"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."albums" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "artist_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "category_type" "text" NOT NULL,
    "title" "text" NOT NULL,
    "genre" "text" NOT NULL,
    "sub_genres" "text"[] DEFAULT '{}'::"text"[],
    "release_date" "date",
    "cover_image_url" "text",
    "plays" bigint DEFAULT '0'::bigint NOT NULL,
    CONSTRAINT "albums_category_type_check" CHECK (("category_type" = ANY (ARRAY['single'::"text", 'ep'::"text", 'album'::"text"]))),
    CONSTRAINT "title_length" CHECK (("char_length"("title") >= 1))
);


ALTER TABLE "public"."albums" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."artist_profiles" (
    "id" "uuid" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "artist_name" "text" DEFAULT 'Tolu'::"text",
    "artist_image_url" "text",
    "banner_image_url" "text",
    "bio" "text",
    "spotify_url" "text",
    "deezer_url" "text",
    "youtube_music_url" "text",
    "audiomack_url" "text",
    "soundcloud_url" "text",
    "apple_music_url" "text",
    CONSTRAINT "artist_name_length" CHECK (("char_length"("artist_name") >= 3))
);


ALTER TABLE "public"."artist_profiles" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tracks" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "album_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "track_number" integer NOT NULL,
    "track_title" "text" NOT NULL,
    "audio_file_url" "text",
    "featured_artists" "text"[] DEFAULT '{}'::"text"[],
    "plays" bigint DEFAULT '0'::bigint NOT NULL,
    CONSTRAINT "track_number_positive" CHECK (("track_number" >= 1)),
    CONSTRAINT "track_title_length" CHECK (("char_length"("track_title") >= 1))
);


ALTER TABLE "public"."tracks" OWNER TO "postgres";


ALTER TABLE ONLY "public"."albums"
    ADD CONSTRAINT "albums_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."artist_profiles"
    ADD CONSTRAINT "artist_profiles_artist_name_key" UNIQUE ("artist_name");



ALTER TABLE ONLY "public"."artist_profiles"
    ADD CONSTRAINT "artist_profiles_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."tracks"
    ADD CONSTRAINT "tracks_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."albums"
    ADD CONSTRAINT "albums_artist_id_fkey" FOREIGN KEY ("artist_id") REFERENCES "public"."artist_profiles"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."artist_profiles"
    ADD CONSTRAINT "artist_profiles_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tracks"
    ADD CONSTRAINT "tracks_album_id_fkey" FOREIGN KEY ("album_id") REFERENCES "public"."albums"("id") ON DELETE CASCADE;



CREATE POLICY "Public artist profiles are viewable by everyone." ON "public"."artist_profiles" FOR SELECT USING (true);



CREATE POLICY "Public can read albums" ON "public"."albums" FOR SELECT USING (true);



CREATE POLICY "Public can read tracks" ON "public"."tracks" FOR SELECT USING (true);



CREATE POLICY "Users can insert their own artist profile." ON "public"."artist_profiles" FOR INSERT WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "id"));



CREATE POLICY "Users can update their own artist profile." ON "public"."artist_profiles" FOR UPDATE USING ((( SELECT "auth"."uid"() AS "uid") = "id"));



ALTER TABLE "public"."albums" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."artist_profiles" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "artists can delete their own albums" ON "public"."albums" FOR DELETE USING ((( SELECT "auth"."uid"() AS "uid") = "artist_id"));



CREATE POLICY "artists can delete their own tracks" ON "public"."tracks" FOR DELETE USING ((( SELECT "auth"."uid"() AS "uid") = ( SELECT "albums"."artist_id"
   FROM "public"."albums"
  WHERE ("albums"."id" = "tracks"."album_id"))));



CREATE POLICY "artists can insert their own albums" ON "public"."albums" FOR INSERT WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = "artist_id"));



CREATE POLICY "artists can insert their own tracks" ON "public"."tracks" FOR INSERT WITH CHECK ((( SELECT "auth"."uid"() AS "uid") = ( SELECT "albums"."artist_id"
   FROM "public"."albums"
  WHERE ("albums"."id" = "tracks"."album_id"))));



CREATE POLICY "artists can update their own albums" ON "public"."albums" FOR UPDATE USING ((( SELECT "auth"."uid"() AS "uid") = "artist_id"));



CREATE POLICY "artists can update their own tracks" ON "public"."tracks" FOR UPDATE USING ((( SELECT "auth"."uid"() AS "uid") = ( SELECT "albums"."artist_id"
   FROM "public"."albums"
  WHERE ("albums"."id" = "tracks"."album_id"))));



ALTER TABLE "public"."tracks" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";




















































































































































































GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_new_user"() TO "service_role";


















GRANT ALL ON TABLE "public"."albums" TO "anon";
GRANT ALL ON TABLE "public"."albums" TO "authenticated";
GRANT ALL ON TABLE "public"."albums" TO "service_role";



GRANT ALL ON TABLE "public"."artist_profiles" TO "anon";
GRANT ALL ON TABLE "public"."artist_profiles" TO "authenticated";
GRANT ALL ON TABLE "public"."artist_profiles" TO "service_role";



GRANT ALL ON TABLE "public"."tracks" TO "anon";
GRANT ALL ON TABLE "public"."tracks" TO "authenticated";
GRANT ALL ON TABLE "public"."tracks" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";






























RESET ALL;
