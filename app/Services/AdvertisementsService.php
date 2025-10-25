<?php

namespace App\Services;

use App\Models\Advertisement;
use Illuminate\Support\Facades\Storage;

class AdvertisementsService
{
    public function __construct(protected FileService $fileService)
    {
    }

    public function createAdvertisement($title, $image)
    {
        $imagePath = $this->saveAdvertisementImage($image);

        $advertisement = Advertisement::create([
            'title' => $title,
            'image' => $imagePath,
        ]);

        $htmlFilePath = $this->generateAdvertisementHtmlFile($advertisement);

        return $this->createAdvertisementZip($advertisement, $htmlFilePath);
    }

    public function saveAdvertisementImage($imageFile): string
    {
        return $imageFile->store('advertisements', 'public');
    }

    public function generateAdvertisementHtmlFile($advertisement): string
    {
        $adName = "advertisement_{$advertisement->id}.html";

        $htmlContent = file_get_contents(resource_path('templates/index.html'));

        $htmlContent = str_replace([
            '{{ lead_url }}',
            '{{ track_url }}',
            '{{ ad_img_src }}',
            '{{ ad_title }}',
        ], [
            url("/api/{$adName}/lead"),
            url("/api/{$adName}/track"),
            asset("storage/{$advertisement->image}"),
            $advertisement->title,
        ], $htmlContent);

        Storage::disk('local')->put($adName, $htmlContent);

        return Storage::disk('local')->path($adName);
    }

    public function createAdvertisementZip($advertisement, $htmlFilePath): array
    {
        $zipFileName = "advertisement_{$advertisement->id}.zip";

        $zipPath = $this->fileService->createZipArchive($zipFileName, [
            $htmlFilePath => "index.html",
            resource_path('templates/scripts.js') => 'scripts.js',
        ]);

        return [$zipPath, $zipFileName];
    }
}