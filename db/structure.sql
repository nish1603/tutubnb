CREATE TABLE "addresses" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "address_line1" varchar(255), "address_line2" varchar(255), "city" varchar(255), "state" varchar(255), "pincode" varchar(255), "country" varchar(255), "place_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "deals" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "start_date" date, "end_date" date, "price" float, "guests" integer, "user_id" integer, "place_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "cancel" boolean DEFAULT 'f', "accept" boolean, "request" boolean DEFAULT 't', "complete" boolean DEFAULT 'f');
CREATE TABLE "details" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "accomodation" integer, "bedrooms" integer, "beds" integer, "bed_type" varchar(255), "bathrooms" integer, "size" float, "unit" varchar(255), "pets" boolean, "place_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "photos" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "photo_file_name" varchar(255), "photo_content_type" varchar(255), "photo_file_size" integer, "place_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "avatar_file_name" varchar(255), "avatar_content_type" varchar(255), "avatar_file_size" integer, "avatar_updated_at" datetime);
CREATE TABLE "places" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar(255), "description" text, "property_type" varchar(255), "room_type" varchar(255), "daily" float, "weekend" float, "weekly" float, "monthly" float, "add_guests" integer, "add_price" float, "user_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "verified" boolean DEFAULT 'f', "hidden" boolean DEFAULT 'f');
CREATE TABLE "places_tags" ("place_id" integer, "tag_id" integer);
CREATE TABLE "reviews" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "subject" varchar(255), "description" text, "ratings" integer, "user_id" integer, "place_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "rules" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "rules" varchar(255), "availables" varchar(255), "place_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar(255) NOT NULL);
CREATE TABLE "tags" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "tag" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "users" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "first_name" varchar(255), "last_name" varchar(255), "email" varchar(255), "password_digest" varchar(255), "gender" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "birth_date" date, "school" varchar(255), "describe" text, "live" varchar(255), "work" varchar(255), "verified" boolean DEFAULT 'f', "avatar_file_name" varchar(255), "avatar_content_type" varchar(255), "avatar_file_size" integer, "avatar_updated_at" datetime, "wallet" float DEFAULT 0.0, "admin" boolean DEFAULT 'f', "activation_link" varchar(255), "activated" boolean DEFAULT 't');
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
INSERT INTO schema_migrations (version) VALUES ('20120830050434');

INSERT INTO schema_migrations (version) VALUES ('20120830091318');

INSERT INTO schema_migrations (version) VALUES ('20120830091739');

INSERT INTO schema_migrations (version) VALUES ('20120901114024');

INSERT INTO schema_migrations (version) VALUES ('20120903050253');

INSERT INTO schema_migrations (version) VALUES ('20120903050455');

INSERT INTO schema_migrations (version) VALUES ('20120904045559');

INSERT INTO schema_migrations (version) VALUES ('20120904065329');

INSERT INTO schema_migrations (version) VALUES ('20120905050021');

INSERT INTO schema_migrations (version) VALUES ('20120905055439');

INSERT INTO schema_migrations (version) VALUES ('20120906162437');

INSERT INTO schema_migrations (version) VALUES ('20120908120043');

INSERT INTO schema_migrations (version) VALUES ('20120909115847');

INSERT INTO schema_migrations (version) VALUES ('20120911101223');

INSERT INTO schema_migrations (version) VALUES ('20120911154835');

INSERT INTO schema_migrations (version) VALUES ('20120912063339');

INSERT INTO schema_migrations (version) VALUES ('20120913123157');

INSERT INTO schema_migrations (version) VALUES ('20120913190326');