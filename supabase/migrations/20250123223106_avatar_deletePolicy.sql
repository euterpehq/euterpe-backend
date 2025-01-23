CREATE POLICY "User can delete an avatar"
ON storage.objects
FOR DELETE
USING (bucket_id = 'avatars' AND owner = auth.uid());