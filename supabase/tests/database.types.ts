export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  public: {
    Tables: {
      albums: {
        Row: {
          artist_id: string
          category_type: string
          cover_image_url: string | null
          created_at: string | null
          genre: string
          id: string
          plays: number
          release_date: string | null
          sub_genres: string[] | null
          title: string
          updated_at: string | null
        }
        Insert: {
          artist_id: string
          category_type: string
          cover_image_url?: string | null
          created_at?: string | null
          genre: string
          id?: string
          plays?: number
          release_date?: string | null
          sub_genres?: string[] | null
          title: string
          updated_at?: string | null
        }
        Update: {
          artist_id?: string
          category_type?: string
          cover_image_url?: string | null
          created_at?: string | null
          genre?: string
          id?: string
          plays?: number
          release_date?: string | null
          sub_genres?: string[] | null
          title?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "albums_artist_id_fkey"
            columns: ["artist_id"]
            isOneToOne: false
            referencedRelation: "artist_profiles"
            referencedColumns: ["id"]
          },
        ]
      }
      artist_profiles: {
        Row: {
          apple_music_url: string | null
          artist_image_url: string | null
          artist_name: string | null
          audiomack_url: string | null
          banner_image_url: string | null
          bio: string | null
          deezer_url: string | null
          id: string
          soundcloud_url: string | null
          spotify_url: string | null
          updated_at: string | null
          youtube_music_url: string | null
        }
        Insert: {
          apple_music_url?: string | null
          artist_image_url?: string | null
          artist_name?: string | null
          audiomack_url?: string | null
          banner_image_url?: string | null
          bio?: string | null
          deezer_url?: string | null
          id: string
          soundcloud_url?: string | null
          spotify_url?: string | null
          updated_at?: string | null
          youtube_music_url?: string | null
        }
        Update: {
          apple_music_url?: string | null
          artist_image_url?: string | null
          artist_name?: string | null
          audiomack_url?: string | null
          banner_image_url?: string | null
          bio?: string | null
          deezer_url?: string | null
          id?: string
          soundcloud_url?: string | null
          spotify_url?: string | null
          updated_at?: string | null
          youtube_music_url?: string | null
        }
        Relationships: []
      }
      tracks: {
        Row: {
          album_id: string
          audio_file_url: string | null
          created_at: string | null
          featured_artists: string[] | null
          id: string
          plays: number
          track_number: number
          track_title: string
          updated_at: string | null
        }
        Insert: {
          album_id: string
          audio_file_url?: string | null
          created_at?: string | null
          featured_artists?: string[] | null
          id?: string
          plays?: number
          track_number: number
          track_title: string
          updated_at?: string | null
        }
        Update: {
          album_id?: string
          audio_file_url?: string | null
          created_at?: string | null
          featured_artists?: string[] | null
          id?: string
          plays?: number
          track_number?: number
          track_title?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "tracks_album_id_fkey"
            columns: ["album_id"]
            isOneToOne: false
            referencedRelation: "albums"
            referencedColumns: ["id"]
          },
        ]
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type PublicSchema = Database[Extract<keyof Database, "public">]

export type Tables<
  PublicTableNameOrOptions extends
    | keyof (PublicSchema["Tables"] & PublicSchema["Views"])
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
        Database[PublicTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? (Database[PublicTableNameOrOptions["schema"]]["Tables"] &
      Database[PublicTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : PublicTableNameOrOptions extends keyof (PublicSchema["Tables"] &
        PublicSchema["Views"])
    ? (PublicSchema["Tables"] &
        PublicSchema["Views"])[PublicTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  PublicTableNameOrOptions extends
    | keyof PublicSchema["Tables"]
    | { schema: keyof Database },
  TableName extends PublicTableNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = PublicTableNameOrOptions extends { schema: keyof Database }
  ? Database[PublicTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : PublicTableNameOrOptions extends keyof PublicSchema["Tables"]
    ? PublicSchema["Tables"][PublicTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  PublicEnumNameOrOptions extends
    | keyof PublicSchema["Enums"]
    | { schema: keyof Database },
  EnumName extends PublicEnumNameOrOptions extends { schema: keyof Database }
    ? keyof Database[PublicEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = PublicEnumNameOrOptions extends { schema: keyof Database }
  ? Database[PublicEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : PublicEnumNameOrOptions extends keyof PublicSchema["Enums"]
    ? PublicSchema["Enums"][PublicEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof PublicSchema["CompositeTypes"]
    | { schema: keyof Database },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof Database
  }
    ? keyof Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends { schema: keyof Database }
  ? Database[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof PublicSchema["CompositeTypes"]
    ? PublicSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never
