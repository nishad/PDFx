SWORD2 DSpace bulk uploader
--------------------

A python script to submit large numbers of files to a SWORD2-compatible repository, specifically DSpace 1.8x.
Built on the SWORD2 python client library: https://github.com/swordapp/python-client-sword2

-----------------------------------------------
Source:

https://code.soundsoftware.ac.uk/projects/sworduploader/repository

-----------------------------------------------
Dependencies:

- python 2.X

- sword2 library: https://github.com/swordapp/python-client-sword2

-----------------------------------------------
Installation:

- no installation required, simply copy the script sworduploader.py to a suitable location. The first time you run the script, it will create the sword2_logging.conf file.
- a server.cfg file is also available. If the --servicedoc option is not used, sworduploader will read the first line of server.cfg and use it as the server's URL. If the server.cfg is missing, it will default to C4DM's server.

-----------------------------------------------
Usage:

sworduploader[-h] [--username USER_NAME] [--title TITLE]
                        [--author AUTHOR [AUTHOR ...]] [--date DATE]
                        [--servicedoc DSPACEURL]
                        data

Bulk upload to DSpace using SWORDv2.

positional arguments:
  data                  Accepts: METSDSpaceSIP and BagIt packages, simple zip
                        files, directories, single files. NOTE: METSDSpaceSIP
                        packages are only accepted by Collections with a
                        workflow!

optional arguments:
  -h, --help            show this help message and exit
  --username USER_NAME  DSpace username.
  --title TITLE         Title (ignored for METS packages).
  --author AUTHOR [AUTHOR ...]
                        Author(s) (ignored for METS packages). Accepts
                        multiple entries in the format "Surname, Name"
  --date DATE           Date of creation (string) (ignored for METS packages).
  --zip                 If "data" is a directory, compress it and post it as a
                        single file. The zip file will be saved along with the
                        individual files.
  --servicedoc SD  		Url of the SWORDv2 service document (default: use
                        server.cfg if available, otherwise http://c4dm.eecs.qm
                        ul.ac.uk/rdr/swordv2/servicedocument

If the submission is created successfully, it will remain open to be completed
with the necessary metadata and licenses, using the DSpace web interface. The
submission can be found in the "My Account -> Submissions" section of the
user's area.

