<?php

namespace App\Services;

use Illuminate\Support\Facades\Storage;

class FileService
{
    public function createZipArchive($zipFileName, $files): string
    {
        $zipPath = Storage::disk('local')->path($zipFileName);
        $zip = new \ZipArchive();

        if ($zip->open($zipPath, \ZipArchive::CREATE | \ZipArchive::OVERWRITE) === true) {
            foreach ($files as $filePath => $localName) {
                $zip->addFile($filePath, $localName);
            }

            $zip->close();
        }

        return $zipPath;
    }
}