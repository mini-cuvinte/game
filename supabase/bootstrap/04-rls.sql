-- Keep public tables inaccessible through direct Data API reads.
ALTER TABLE "public"."dictionary_words" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."player_profiles" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."player_results" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."room_events" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."room_members" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."rooms" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "public"."word_requests" ENABLE ROW LEVEL SECURITY;
