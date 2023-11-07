[Unit]
Description=SAP Instance SAPT02_01
After=remote-fs.target time-sync.target SAPT01_00.service
Wants=remote-fs.target

[Service]
User=t01adm
Group=sapsys
TimeoutStartSec=120sec
TimeoutStopSec=360sec
Type=notify
NotifyAccess=all
KillMode=process
WorkingDirectory=/usr/sap/T01/SYS/exe/uc/linuxx86_64
Environment=LD_LIBRARY_PATH=/usr/sap/T01/DVEBMGS00/exe
ExecStart=/usr/sap/T01/SYS/exe/uc/linuxx86_64/sapcontrol -nr 01 -function StartSystem && sleep 10 && /usr/sap/T01/SYS/exe/uc/linuxx86_64/sapcontrol -nr 00 -function StartSystem
KillSignal=SIGINT
Slice=SAP.slice
SyslogIdentifier=SAPT02_01
LimitNOFILE=1048576
TasksMax=infinity
Restart=on-failure
RestartSec=60s

[Install]
WantedBy=multi-user.target


# Automatically generated. Do not modify.

[Unit]
Description=SAP Instance SAPT02_02
After=remote-fs.target time-sync.target SAPT01_01.service 
Wants=remote-fs.target

[Service]
User=tj1adm
Group=sapsys
TimeoutStartSec=120sec
TimeoutStopSec=360sec
Type=notify
NotifyAccess=all
KillMode=process
WorkingDirectory=/usr/sap/T01/ASCS01/work
Environment=LD_LIBRARY_PATH=/usr/sap/T01/ASCS01/exe
ExecStart=/usr/sap/T01/SYS/exe/uc/linuxx86_64/sapcontrol -nr 02 -function StartSystem && sleep 10 && /usr/sap/T01/SYS/exe/uc/linuxx86_64/sapcontrol -nr 03 -function StartSystem
KillSignal=SIGINT
Slice=SAP.slice
SyslogIdentifier=SAPT02_02
LimitNOFILE=1048576
TasksMax=infinity
Restart=on-failure
RestartSec=60s

[Install]
WantedBy=multi-user.target
