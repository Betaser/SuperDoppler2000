# Polling does not require an extra module
import cv2

import os
import time

folder = os.path.abspath("./ruby_on_rails_app/app/assets/raw_images")
write_folder = os.path.abspath("./ruby_on_rails_app/app/assets/images")
# Assume the files always exist, just their content changes.

files_and_folders = os.listdir(folder)
files = []
local_files = []
for file in files_and_folders:
	path = (folder + "/" + file).strip()
	if os.path.isfile(path):
		files.append(path)
		local_files.append(file)

modify_times = { file: -9.0 for file in files }

while True:
	for file, local_file in zip(files, local_files):
		# only pngs work?
		if file.endswith(".png"):
			last_modified = modify_times[file]

			current_modified = os.path.getmtime(file)

			# with time sleep interval of 0.1, runs twice sometimes
			if current_modified - last_modified > 1.0:
				modify_times[file] = current_modified
				# print(f"File {file} modified at time {current_modified}")
				image = cv2.imread(file)
				if image is None:
					print("unable to open file:", file)
				else:
					final_img = cv2.resize(image, (600, 400), interpolation=cv2.INTER_CUBIC)
					write_path = write_folder + "/" + local_file
					# cv2.imwrite("blah.png", final_img)
					cv2.imwrite(write_path, final_img)

					# print(file, "exists")
		
	time.sleep(0.1)