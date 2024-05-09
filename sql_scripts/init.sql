-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CreateTable
CREATE TABLE "course" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "code" VARCHAR,
    "name" VARCHAR,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "department" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "code" VARCHAR,
    "name" VARCHAR,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "discipline" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "code" VARCHAR,
    "name" VARCHAR,
    "description" VARCHAR,
    "department_id" UUID,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "discipline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "discipline_class" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "class_number" VARCHAR,
    "discipline_id" UUID,
    "semester" VARCHAR,
    "professor" VARCHAR,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "discipline_class_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "discipline_class_schedule" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "discipline_class_id" UUID,
    "day_of_week" VARCHAR,
    "start_time" TIME(6),
    "end_time" TIME(6),
    "class_type" VARCHAR,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "discipline_class_schedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "discipline_course" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "discipline_id" UUID,
    "course_id" UUID,
    "mandatory" BOOLEAN,
    "period" INTEGER,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "discipline_course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "prerequisite" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "discipline_course_id" UUID,
    "prerequisite_discipline_id" UUID,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "prerequisite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" TEXT NOT NULL,
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

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL,
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "VerificationToken" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Account_provider_providerAccountId_key" ON "Account"("provider", "providerAccountId");

-- CreateIndex
CREATE UNIQUE INDEX "Session_sessionToken_key" ON "Session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_token_key" ON "VerificationToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "VerificationToken_identifier_token_key" ON "VerificationToken"("identifier", "token");

-- AddForeignKey
ALTER TABLE "discipline" ADD CONSTRAINT "discipline_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "department"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "discipline_class" ADD CONSTRAINT "discipline_class_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "discipline"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "discipline_class_schedule" ADD CONSTRAINT "discipline_class_schedule_discipline_class_id_fkey" FOREIGN KEY ("discipline_class_id") REFERENCES "discipline_class"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "discipline_course" ADD CONSTRAINT "discipline_course_course_id_fkey" FOREIGN KEY ("course_id") REFERENCES "course"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "discipline_course" ADD CONSTRAINT "discipline_course_discipline_id_fkey" FOREIGN KEY ("discipline_id") REFERENCES "discipline"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "prerequisite" ADD CONSTRAINT "prerequisite_discipline_course_id_fkey" FOREIGN KEY ("discipline_course_id") REFERENCES "discipline_course"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "prerequisite" ADD CONSTRAINT "prerequisite_prerequisite_discipline_id_fkey" FOREIGN KEY ("prerequisite_discipline_id") REFERENCES "discipline"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Session" ADD CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;
