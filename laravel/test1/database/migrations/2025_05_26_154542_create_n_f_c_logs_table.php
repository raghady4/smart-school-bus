<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('nfc_logs', function (Blueprint $table) {
            $table->bigIncrements('nfc_logs_id');
            // $table->unsignedBigInteger('device_id');
            $table->unsignedBigInteger('student_id')->nullable();
            $table->unsignedBigInteger('bus_id');
            $table->boolean('is_active');
            $table->timestamp('timestamp')->useCurrent();
            $table->timestamps();

            // $table->foreign('device_id')->references('devices_id')->on('devices')->onDelete('cascade');
            $table->foreign('student_id')->references('student_id')->on('students')->onDelete('cascade');
            $table->foreign('bus_id')->references('bus_id')->on('buses')->onDelete('cascade');

        });
    }

    public function down(): void
    {
        Schema::dropIfExists('nfc_logs');
    }
};
