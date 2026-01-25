<?php
$zipFile = '../ui_update.zip';
$extractTo = '../';

$zip = new ZipArchive;
if ($zip->open($zipFile) === TRUE) {
    $zip->extractTo($extractTo);
    $zip->close();
    echo 'UI Update successful!';
} else {
    echo 'Failed to open the zip file.';
}
?>
