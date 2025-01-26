CREATE POLICY "User can delete an avatar"
ON storage.objects
FOR DELETE
USING (bucket_id = 'avatars'::text AND owner_id = auth.uid()::text);