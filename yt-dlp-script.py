import os
import subprocess
from datetime import datetime
import yaml

# load the config.yaml
with open("config.yaml", "r") as f:
    config = yaml.safe_load(f)

yt_dlp_path = config["yt_dlp_path"]
base_dir = config["download_dir"]

#1: setup directory
os.makedirs(base_dir, exist_ok=True)
os.chdir(base_dir)

#2: create folder with datetime format
now = datetime.now().strftime("%Y%m%d_%H%M%S")
folder = f"yt-dlp_{now}"
folder_path = os.path.join(base_dir, folder)
os.makedirs(folder_path, exist_ok=True)

#3: get YouTube URL
url = input("Enter YouTube URL: ").strip()

#4: show available formats
subprocess.run([yt_dlp_path, "-F", url])

#5: quality prompt
qualities = {
    "1": "144",
    "2": "240",
    "3": "360",
    "4": "480",
    "5": "720",
    "6": "1080",
    "7": "1440",
    "8": "2160",
    "9": "best"
}

print("\nSelect video quality:")
for k, v in qualities.items():
    print(f"[{k}] {v}p" if v != "best" else f"[{k}] Best")

choice = input("Enter the number of your choice: ").strip()

if choice not in qualities:
    print("Invalid selection. Exiting...")
    exit(1)

quality = qualities[choice]

#6: run yt-dlp with selected quality
if quality == "best":
    format_string = "bestvideo+bestaudio"
else:
    format_string = (
        f"bv[height={quality}][vcodec*=avc][protocol*=https]+ba[acodec*=mp] / "
        f"bv[height={quality}][vcodec*=av01]+ba[acodec*=mp] / "
        f"bv[height={quality}][vcodec*=vp]+ba[acodec*=mp] / "
        f"bv[height<={quality}][vcodec*=avc][protocol*=https]+ba[acodec*=mp]"
    )

subprocess.run([
    yt_dlp_path,
    "-P", folder_path,
    "-f", format_string,
    "--merge-output-format", "mp4",
    url
])

input("\nPress Enter to exit...")