/*
File Name:    Detect-SSD-Drive.sql
Description:  Returns a list of devices with a SSD installed.
*/

SELECT DISTINCT
cs.Model0 AS 'Model', sys.Name0 AS 'Machine Name',
sys.User_Name0 AS 'Last Logged on User', sys.User_Domain0 AS 'Domain',
sys.AD_Site_Name0 AS 'AD Site', ld.Name0 AS 'Drive Letter',
CASE
when vdisk.Model0 like '%SSD%' then 'Known SSD Drive'
when vdisk.Model0 = 'LITEONIT LF-64M1S' or
Vdisk.Model0 ='LITEONIT LFT-128M2S' then 'Known SSD Drive'
else vdisk.Model0 END as 'SSD Drive?',
REPLACE(CONVERT(varchar, cast(ld.Size0 AS money),1), '.00', '') as 'Total Drive Space on C: in MB',
REPLACE(CONVERT(varchar, cast((mem.TotalPhysicalMemory0 / 1024) as money),1), '.00', '') AS 'Total Ram Installed in MB'


FROM v_R_System AS sys INNER JOIN
v_GS_COMPUTER_SYSTEM AS cs ON sys.ResourceID = cs.ResourceID INNER JOIN
v_GS_LOGICAL_DISK AS ld ON sys.ResourceID = ld.ResourceID INNER JOIN
v_GS_X86_PC_MEMORY AS mem ON sys.ResourceID = mem.ResourceID INNER JOIN
v_gs_Disk as vdisk on sys.resourceid = vdisk.resourceid

WHERE (vdisk.Model0 NOT LIKE '%USB%')
AND (vdisk.Model0 NOT LIKE '%SD MEMORY%')
AND (vdisk.Model0 <> 'SMART')
AND (sys.Active0 = 1) AND (sys.Decommissioned0 = 0)
AND (sys.SMBIOS_GUID0 IS NOT NULL) AND (ld.Name0 = 'C:')
