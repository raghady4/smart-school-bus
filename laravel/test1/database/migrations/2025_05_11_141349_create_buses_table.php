<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateBusesTable extends Migration
{

    public function up()
    {
        Schema::create('buses', function (Blueprint $table) {
        $table->bigIncrements('bus_id');

        $table->string('bus_number')->unique();
        $table->unsignedBigInteger('driver_id')->nullable();
        $table->unsignedBigInteger('school_id');
        $table->unsignedBigInteger('area_id');
        $table->string('color')->nullable();
        $table->string('current_location')->nullable();
        $table->boolean('is_active')->default(true);
        $table->timestamps();

        $table->foreign('driver_id')->references('user_id')->on('users')->onDelete('set null');
        $table->foreign('school_id')->references('school_id')->on('schools')->onDelete('cascade');
        $table->foreign('area_id')->references('area_id')->on('areas')->onDelete('cascade');
        });
    }

   
    public function down()
    {
        Schema::dropIfExists('buses');
    }
}
