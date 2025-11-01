<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateStudentsTable extends Migration
{
    public function up()
    {
        Schema::create('students', function (Blueprint $table) {
            $table->id('student_id');
            $table->string('full_name');
            // $table->string('photo')->nullable();
            $table->unsignedBigInteger('area_id');
            $table->string('address');
            $table->string('nfc_logs_id')->unique();
            $table->unsignedBigInteger('parent_id');
            $table->unsignedBigInteger('bus_id')->nullable();
            $table->string('status')->default('active');
            $table->unsignedBigInteger('school_id');
            $table->timestamps();

            $table->foreign('area_id')->references('area_id')->on('areas')->onDelete('cascade');
            $table->foreign('parent_id')->references('user_id')->on('users')->onDelete('cascade');
            $table->foreign('bus_id')->references('bus_id')->on('buses')->onDelete('set null');
            $table->foreign('school_id')->references('school_id')->on('schools')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::dropIfExists('students');
    }
}
