-- Enable the uuid-ossp extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create tables
CREATE TABLE IF NOT EXISTS "course" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "code" TEXT,
    "name" TEXT,
    "created_at" TIMESTAMP(6)
);

CREATE TABLE IF NOT EXISTS "department" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "code" TEXT,
    "name" TEXT,
    "created_at" TIMESTAMP(6)
);

CREATE TABLE IF NOT EXISTS "equivalency_group" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "created_at" TIMESTAMP(6)
);

CREATE TABLE IF NOT EXISTS "discipline" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "code" TEXT,
    "name" TEXT,
    "description" TEXT,
    "department_id" UUID,
    "created_at" TIMESTAMP(6),
    "equivalency_group_id" UUID,
    FOREIGN KEY ("department_id") REFERENCES "department"("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ("equivalency_group_id") REFERENCES "equivalency_group"("id") ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "user" (
    "id" TEXT PRIMARY KEY,
    "name" TEXT,
    "email" TEXT UNIQUE NOT NULL,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,
    "courseId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    FOREIGN KEY ("courseId") REFERENCES "course"("id") ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "completed_discipline" (
    "userId" TEXT,
    "disciplineId" UUID,
    PRIMARY KEY ("userId", "disciplineId"),
    FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY ("disciplineId") REFERENCES "discipline"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "discipline_class" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "class_number" TEXT,
    "discipline_id" UUID,
    "semester" TEXT,
    "professor" TEXT,
    "created_at" TIMESTAMP(6),
    FOREIGN KEY ("discipline_id") REFERENCES "discipline"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS "discipline_class_schedule" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "discipline_class_id" UUID,
    "day_of_week" TEXT,
    "start_time" TIME(6),
    "end_time" TIME(6),
    "class_type" TEXT,
    "created_at" TIMESTAMP(6),
    FOREIGN KEY ("discipline_class_id") REFERENCES "discipline_class"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS "discipline_course" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "discipline_id" UUID,
    "course_id" UUID,
    "mandatory" BOOLEAN,
    "period" INTEGER,
    "created_at" TIMESTAMP(6),
    FOREIGN KEY ("course_id") REFERENCES "course"("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ("discipline_id") REFERENCES "discipline"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS "prerequisite" (
    "id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "discipline_course_id" UUID,
    "prerequisite_discipline_id" UUID,
    "created_at" TIMESTAMP(6),
    FOREIGN KEY ("discipline_course_id") REFERENCES "discipline_course"("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY ("prerequisite_discipline_id") REFERENCES "discipline"("id") ON DELETE NO ACTION ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS "account" (
    "userId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "providerAccountId" TEXT NOT NULL,
    "refresh_token" TEXT,
    "access_token" TEXT,
    "expires_at" INTEGER,
    "token_type" TEXT,
    "scope" TEXT,
    "id_token" TEXT,
    "session_state" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("provider", "providerAccountId"),
    FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "session" (
    "sessionToken" TEXT PRIMARY KEY,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "verification_token" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    PRIMARY KEY ("identifier", "token")
);

-- Create indexes
CREATE INDEX IF NOT EXISTS "user_email_key" ON "user"("email");
CREATE UNIQUE INDEX IF NOT EXISTS "session_sessionToken_key" ON "session"("sessionToken");
CREATE UNIQUE INDEX IF NOT EXISTS "verification_token_token_key" ON "verification_token"("token");