# VK Bookmarks Image Downloader

## Overview
This PowerShell script is designed to download images from VKontakte (VK) bookmarks. It allows users to specify a range of posts to download from, set a custom save path for the downloaded images, and provide their VK access token URL.

## Features
- Download images from specified range of VK bookmarks.
- Customizable start point and number of posts to download.
- Optional custom save path for downloaded images.
- Ability to specify VK access token URL as an argument.
- Automatic handling of VK's 100 post limit per request.
- Retry mechanism for handling download failures.

## Prerequisites
Before running the script, ensure you have:
- PowerShell installed on your system.
- Access to the internet to reach VK's API.
- A valid VK access token.

## Usage
To use the script, follow these steps:

1. Clone or download the script to your local machine.
2. Open PowerShell and navigate to the script's directory.
3. Run the script with the desired parameters:

   ```powershell
   .\vk_bookmarks.ps1 -startFrom [start] -getCount [count] -savePath [path] -urlWithToken [VK access token URL]
   ```

   - `startFrom`: The starting position (integer) for downloading posts (e.g., 0).
   - `getCount`: The number of posts to download (e.g., 100).
   - `savePath`: (Optional) The path where images will be saved. If not specified, images will be saved in a folder named with the current date in MMYY format in the script's directory.
   - `urlWithToken`: Your VK access token URL.

   Example:

   ```powershell
   .\vk_bookmarks.ps1 -startFrom 200 -getCount 200 -savePath 'C:\Users\admin\Images' -urlWithToken 'https://oauth.vk.com/blank.html#access_token=123'
   ```

## Note
- The script is designed to handle VK's limit of 100 posts per request. If more than 100 posts are requested, it will automatically split the requests.
- If the download of an image fails, the script will retry up to 20 times before skipping to the next image.

## Contributing
Contributions to this project are welcome. Please ensure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)