CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION handle_new_user();


create policy "Anyone can upload a banner."
on "storage"."objects"
as permissive
for insert
to public
with check ((bucket_id = 'banners'::text));


create policy "Anyone can upload an avatar."
on "storage"."objects"
as permissive
for insert
to public
with check ((bucket_id = 'avatars'::text));


create policy "Artists can upload covers"
on "storage"."objects"
as permissive
for insert
to public
with check ((bucket_id = 'album_covers'::text));


create policy "Artists can upload tracks"
on "storage"."objects"
as permissive
for insert
to public
with check ((bucket_id = 'track_audio'::text));


create policy "Avatar images are publicly accessible."
on "storage"."objects"
as permissive
for select
to public
using ((bucket_id = 'avatars'::text));


create policy "Banner images are publicly accessible."
on "storage"."objects"
as permissive
for select
to public
using ((bucket_id = 'banners'::text));


create policy "Public read for album covers"
on "storage"."objects"
as permissive
for select
to public
using ((bucket_id = 'album_covers'::text));


create policy "Public read for track audio"
on "storage"."objects"
as permissive
for select
to public
using ((bucket_id = 'track_audio'::text));



