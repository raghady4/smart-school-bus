<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateSchoolsTable extends Migration
{

    public function up()
    {
        Schema::create('schools', function (Blueprint $table) {
            $table->BigIncrements('school_id');
            // $table->unsignedBigInteger('admin_id')->nullable();
            $table->string('name');
            $table->unsignedBigInteger('area_id');
            $table->timestamps();

            $table->foreign('area_id')->references('area_id')->on('areas')->onDelete('cascade');
            //  $table->foreign('admin_id')->references('user_id')->on('users')->onDelete('set null');
        });
    }


    public function down()
    {
        Schema::dropIfExists('schools');
    }
}
