USE master
GO

IF DB_ID('ILCLONEDALFDB01A') IS NOT NULL
  set noexec on               -- prevent creation when already exists

PRINT 'Restoring Alfresco database...'
GO

RESTORE DATABASE ILCLONEDALFDB01A FROM DISK='/var/opt/mssql/backup/alfrescodb.bak'
WITH MOVE 'ILALFDB01P' to '/var/opt/mssql/data/ILCLONEDALFDB01A.mdf',
MOVE 'ILALFDB01P_log' to '/var/opt/mssql/data/ILCLONEDALFDB01A_log.ldf'
GO

USE ILCLONEDALFDB01A
GO

PRINT 'Updating Alfresco admin password...'
GO

UPDATE alf_node_properties
SET string_value='209c6174da490caeb422f3fa5a7ae634'
WHERE node_id=(SELECT anp1.node_id
    FROM alf_node_properties anp1
    INNER JOIN alf_qname aq1 ON aq1.id = anp1.qname_id
    INNER JOIN alf_node_properties anp2 ON anp2.node_id = anp1.node_id
    INNER JOIN alf_qname aq2 ON aq2.id = anp2.qname_id
    WHERE aq1.local_name like '%password%'
    AND aq2.local_name = 'username' AND anp2.string_value = 'admin')
and qname_id=(SELECT anp1.qname_id
    FROM alf_node_properties anp1
    INNER JOIN alf_qname aq1 ON aq1.id = anp1.qname_id
    INNER JOIN alf_node_properties anp2 ON anp2.node_id = anp1.node_id
    INNER JOIN alf_qname aq2 ON aq2.id = anp2.qname_id
    WHERE aq1.local_name like '%password%'
    AND aq2.local_name = 'username' AND anp2.string_value = 'admin')
GO

PRINT 'Database is up & ready!'
GO
