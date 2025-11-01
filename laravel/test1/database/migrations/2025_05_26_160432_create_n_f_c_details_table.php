<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('nfc_details', function (Blueprint $table) {
            $table->bigIncrements('nfc_details_id');
            $table->unsignedBigInteger('log_id');
            // $table->unsignedBigInteger('device_id');
            $table->enum('action_type',['enter','exit']);
            $table->timestamp('action_time')->nullable();
            // $table->text('note')->nullable();
            $table->timestamps();

            $table->foreign('log_id')->references('nfc_logs_id')->on('nfc_logs')->onDelete('cascade');
            // $table->foreign('device_id')->references('devices_id')->on('devices')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('nfc_details');
    }
};
