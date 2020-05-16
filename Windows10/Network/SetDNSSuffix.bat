:: Author:      Cameron Kollwitz
:: Description: Changes the DNS Suffix on the Device to the TLDs defined in this script.

REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "SearchList"
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "SearchList" /d "domain.tld,dev.domain.tld" /f
REG QUERY HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters /v "SearchList"
