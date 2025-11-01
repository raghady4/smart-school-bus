<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class() extends Migration {
    public function up(): void
    {
        Schema::create('payments', function (Blueprint $table) {
            $table->id('payment_id'); // مفتاح أساسي
            $table->unsignedBigInteger('user_id'); // مفتاح أجنبي للمستخدم
            $table->string('transaction_id')->unique();
            $table->decimal('amount', 12, 2);
            $table->enum('status', ['success', 'failed']);
            $table->json('payload')->nullable();
            $table->timestamps();

            // الربط مع جدول users
            $table->foreign('user_id')
                  ->references('user_id')
                  ->on('users')
                  ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
