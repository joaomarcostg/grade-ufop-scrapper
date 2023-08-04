CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS "course" (
  "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  "code" varchar,
  "name" varchar,
  "created_at" timestamp
);

CREATE TABLE IF NOT EXISTS "department" (
  "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  "code" varchar,
  "name" varchar,
  "created_at" timestamp
);

CREATE TABLE IF NOT EXISTS "discipline" (
  "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  "code" varchar,
  "name" varchar,
  "description" varchar,
  "department_id" uuid,
  "created_at" timestamp
);

CREATE TABLE IF NOT EXISTS "discipline_course" (
  "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  "discipline_id" uuid,
  "course_id" uuid,
  "mandatory" bool,
  "period" integer,
  "created_at" timestamp
);

CREATE TABLE IF NOT EXISTS "discipline_class" (
  "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  "class_number" varchar,
  "discipline_id" uuid,
  "semester" varchar,
  "professor" varchar,
  "created_at" timestamp
);

CREATE TABLE IF NOT EXISTS "discipline_class_schedule" (
  "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  "discipline_class_id" uuid,
  "day_of_week" varchar,
  "start_time" time,
  "end_time" time,
  "class_type" varchar,
  "created_at" timestamp
);

CREATE TABLE IF NOT EXISTS "prerequisite" (
  "id" uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
  "discipline_course_id" uuid,
  "prerequisite_discipline_id" uuid,
  "created_at" timestamp
);

ALTER TABLE "discipline" ADD FOREIGN KEY ("department_id") REFERENCES "department" ("id");

ALTER TABLE "discipline_course" ADD FOREIGN KEY ("discipline_id") REFERENCES "discipline" ("id");

ALTER TABLE "discipline_course" ADD FOREIGN KEY ("course_id") REFERENCES "course" ("id");

ALTER TABLE "discipline_class" ADD FOREIGN KEY ("discipline_id") REFERENCES "discipline" ("id");

ALTER TABLE "discipline_class_schedule" ADD FOREIGN KEY ("discipline_class_id") REFERENCES "discipline_class" ("id");

ALTER TABLE "prerequisite" ADD FOREIGN KEY ("discipline_course_id") REFERENCES "discipline_course" ("id");

ALTER TABLE "prerequisite" ADD FOREIGN KEY ("prerequisite_discipline_id") REFERENCES "discipline" ("id");
