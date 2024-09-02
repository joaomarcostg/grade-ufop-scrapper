-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- CreateTable
CREATE TABLE IF NOT EXISTS "course" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "code" TEXT,
    "name" TEXT,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "department" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "code" TEXT,
    "name" TEXT,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "equivalency_group" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "created_at" TIMESTAMP(6),

    CONSTRAINT "equivalency_group_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "discipline" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "code" TEXT,
    "name" TEXT,
    "description" TEXT,
    "department_id" UUID,
    "created_at" TIMESTAMP(6),
    "equivalency_group_id" UUID,

    CONSTRAINT "discipline_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "completed_discipline" (
    "userId" TEXT NOT NULL,
    "disciplineId" UUID NOT NULL,

    CONSTRAINT "completed_discipline_pkey" PRIMARY KEY ("userId","disciplineId")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "discipline_class" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "class_number" TEXT,
    "discipline_id" UUID,
    "semester" TEXT,
    "professor" TEXT,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "discipline_class_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "discipline_class_schedule" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "discipline_class_id" UUID,
    "day_of_week" TEXT,
    "start_time" TIME(6),
    "end_time" TIME(6),
    "class_type" TEXT,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "discipline_class_schedule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "discipline_course" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "discipline_id" UUID,
    "course_id" UUID,
    "mandatory" BOOLEAN,
    "period" INTEGER,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "discipline_course_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "prerequisite" (
    "id" UUID NOT NULL DEFAULT uuid_generate_v4(),
    "discipline_course_id" UUID,
    "prerequisite_discipline_id" UUID,
    "created_at" TIMESTAMP(6),

    CONSTRAINT "prerequisite_pkey" PRIMARY KEY ("id")
);

-- CreateTable
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

    CONSTRAINT "account_pkey" PRIMARY KEY ("provider","providerAccountId")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "session" (
    "sessionToken" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "user" (
    "id" TEXT NOT NULL,
    "name" TEXT,
    "email" TEXT NOT NULL,
    "emailVerified" TIMESTAMP(3),
    "image" TEXT,
    "courseId" UUID,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE IF NOT EXISTS "verification_token" (
    "identifier" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "expires" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "verification_token_pkey" PRIMARY KEY ("identifier","token")
);

-- CreateIndex
CREATE UNIQUE INDEX "session_sessionToken_key" ON "session"("sessionToken");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "verification_token_token_key" ON "verification_token"("token");

-- AddForeignKey
ALTER TABLE "discipline" ADD CONSTRAINT "discipline_department_id_fkey" FOREIGN KEY ("department_id") REFERENCES "department"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "discipline" ADD CONSTRAINT "discipline_equivalency_group_id_fkey" FOREIGN KEY ("equivalency_group_id") REFERENCES "equivalency_group"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "completed_discipline" ADD CONSTRAINT "completed_discipline_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "completed_discipline" ADD CONSTRAINT "completed_discipline_disciplineId_fkey" FOREIGN KEY ("disciplineId") REFERENCES "discipline"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

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
ALTER TABLE "account" ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_courseId_fkey" FOREIGN KEY ("courseId") REFERENCES "course"("id") ON DELETE SET NULL ON UPDATE CASCADE;
