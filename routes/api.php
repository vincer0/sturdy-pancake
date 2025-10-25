<?php

use App\Http\Controllers\AdvertisementController;
use Illuminate\Support\Facades\Route;

Route::resource('advertisements', AdvertisementController::class)->only('store');
Route::get('/advertisement/{id}/track', [AdvertisementController::class, 'trackAdvertisement']);
Route::get('/advertisement/{id}/lead', [AdvertisementController::class, 'leadAdvertisement']);
Route::get('/dashboard', [AdvertisementController::class, 'dashboard']);