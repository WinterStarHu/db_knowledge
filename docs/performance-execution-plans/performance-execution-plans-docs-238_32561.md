# Performance Test Report

> 来源: https://www.tencentcloud.com/document/product/238/32561

TencentDB for SQL Server Release Notes and Announcements Release Notes Product Announcements User Guide Product Introduction Product Overview Product Architecture Strengths Use Cases Regions and AZs Major Version Lifecycle Description Features and Differences Instance Type Instance Specifications Storage Types Common Concepts Network Environment License Statement Purchase Guide Billing Overview Product Pricing Purchase Method Renewal Instructions Payment Overdue Refund From Pay-as-You-Go to Monthly Subscription Instance Adjustment Fees Description Local Backup Space Billing Cross-Region Backup Billing Description Database Audit Billing Overview Disk Additional I/O Performance Billing Description Viewing Bill Details Getting Started Creating TencentDB for SQL Server Instance Connecting to TencentDB for SQL Server Instance Managing TencentDB for SQL Server Instance Database Audit Overview Viewing Audit Instance List Enabling Audit Service Viewing Audit Log Log Shipping Modifying Audit Services Disabling Audit Service Authorizing Sub-User to Use Database Audit Operation Guide Constraints and Limits Usage Specifications and Suggestions Maintaining Instance Adjusting Instance Configuration Read-Only Instance Network and Security Account Management Database Management Data Security Parameter Configuration Monitoring and Alarms Backup and Restoration Log Management Publish-Subscribe SSIS Data Migration (New) Data Migration (Legacy) Data Synchronization (DTS) ﻿ Practical Tutorial tencentdb_ChangeLoginPassword Stored Procedure User Manual COS Bulk Insert Stored Procedure User Manual TencentDB for SQL Server Methods for Regular Maintenance TencentDB for SQL Server Optimization of Slow SQL How to Better Use Tempdb Cross-Account Backup Restoration Creating VPC for TencentDB for SQL Server Connecting Kingdee K/3 WISE to TencentDB for SQL Server Account Permissions and Permission Control Enabling and Disabling the CDC Feature Shrinking a Database API Documentation History Introduction API Category Making API Requests Sales and fee related APIs Instance Management related APIs Operation and maintenance management related APIs Network management related APIs Account management related APIs Database management related APIs Security group management related APIs Data security encryption related APIs Parameter configuration related APIs Extended Event related APIs Log management related APIs Read only instance management related APIs Publish and subscribe related APIs Backup related APIs Rollback related APIs Data migration (cold standby migration) related APIs SQL Server Integration Services (SSIS) related APIs Data migration (DTS old version) related APIs Data Types Error Codes FAQs FAQ Overview Purchase Consultation Billing and Purchase Connection and Network Account and Permission Backup and Rollback Data Migration Publish/Subscribe Read-Only Instance Version and Architecture Upgrade Disk Space and Specification Adjustment Monitoring and Alarms Log-Related Parameter Modification Features Performance, Space, and Memory-Related FAQs Service Agreement Service Level Agreement Terms of Service Performance Evaluation Performance Test Report Glossary Contact Us Documentation TencentDB for SQL Server Performance Evaluation Performance Test Report Performance Test Report Download Focus Mode Font Size Last updated: 2024-07-30 16:32:13 Test Tool The performance test in this document is conducted with the TPC-C benchmark load built in HammerDB. TPC-C is a typical OLTP workload that simulates a scenario where a wholesaler with multiple warehouses ships goods to a large number of customers. The adjustment of the number of warehouses can reflect the data size that the database can sustain in the test.
HammerDB download address HammerDB User Manual Overview of the TPC-C test load built in HammerDB Test Environment and Parameters Test instance editions The test instances are of 2008 R2 Enterprise Edition, 2012 Enterprise Edition, 2014 Enterprise Edition, 2016 Enterprise Edition, 2017 Enterprise Edition, and 2019 Enterprise Edition, and 2022 Enterprise Edition.
Test instance specifications Two-node (formerly High Availability Edition) The test two-node (formerly High Availability Edition) instances cover all purchasable specifications, including 1-core 2 GB, 1-core 4 GB, 1-core 8 GB, 2-core 4 GB, 2-core 8 GB, 2-core 16 GB, 4-core 8 GB, 4-core 16 GB, 4-core 32 GB, 8-core 16 GB, 8-core 32 GB, 8-core 64 GB, 12-core 24 GB, 12-core 48 GB, 12-core 96 GB, 16-core 32 GB, 16-core 64 GB, 16-core 128 GB, 24-core 48 GB, 24-core 96 GB, 24-core 192 GB, 32-core 64 GB, 32-core 128 GB, 32-core 256 GB, 48-core 96 GB, 48-core 192 GB, 48-core 384 GB, 64-core 128 GB, 64-core 256 GB, 64-core 512 GB, and 90-core 720 GB.
Single-node (formerly Basic Edition) The test single-node (formerly Basic Edition) instances cover all purchasable specifications, including 1-core 2 GB, 1-core 4 GB, 2-core 4 GB, 2-core 8 GB, 4-core 8 GB, 4-core 16 GB, 8-core 16 GB, 8-core 32 GB, 16-core 32 GB, 16-core 64 GB, 24-core 48 GB, and 24-core 96 GB.
Load generation environment The machines on which HammerDB is installed are of the same models as the database instances, ensuring that the performance of the SQL Server instances can be fully measured in the stress test.
TPC-C benchmark parameters Number of Warehouses = 100: Sets the number of warehouses to 100.
Minutes of Rampup Time = 2: Sets the warm-up time before the test to 2 minutes.
Minutes Test Duration = 5: Sets the test duration to 5 minutes.
Number of virtual users The number of virtual users is the number of concurrent connections. In this document, different numbers of concurrent connections are tested on instances of different editions with different specifications.
Two-node (formerly High Availability Edition) Concurrent Connections

2

4

8

16

32

64

128

256

512

1024

1-core 2 GB

✓

✓

✓

✓

✓

✓

✓

✓

-

-

1-core 4 GB

✓

✓

✓

✓

✓

✓

✓

✓

-

-

1-core 8 GB

✓

✓

✓

✓

✓

✓

✓

✓

-

-

2-core 4 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

2-core 8 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

2-core 16 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

4-core 8 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

4-core 16 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

4-core 32 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

8-core 16 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

8-core 32 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

8-core 64 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

12-core 24 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

12-core 48 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

12-core 96 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

16-core 32 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

16-core 64 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

16-core 128 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

24-core 48 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

24-core 96 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

24-core 192 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

32-core 64 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

32-core 128 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

32-core 256 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

48-cores 96 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

48-core 192 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

48-core 384 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

64-core 128 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

64-core 256 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

64-core 512 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

90-core 720 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓ Single-node (formerly Basic Edition) Concurrent Connections

2

4

8

16

32

64

128

256

512

1,024

1-core 2 GB

✓

✓

✓

✓

✓

✓

✓

✓

-

-

1-core 4 GB

✓

✓

✓

✓

✓

✓

✓

✓

-

-

2-core 4 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

2-core 8 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

4-core 8 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

4-core 16 GB

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

8-core 16 GB MEM

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

8-core 32 GB MEM

✓

✓

✓

✓

✓

✓

✓

✓

✓

-

16-core 32 GB MEM

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

16-core 64 GB MEM

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

24-core 48 GB MEM

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓

24-core 96 GB MEM

✓

✓

✓

✓

✓

✓

✓

✓

✓

✓ Test Method
1.
Prepare the TPC-C workload.
Number of Warehouses: The number of warehouses, which will affect the size of the test database generated.
Virtual Users to Build Schema: The number of concurrent connections when generating the load data, which cannot be larger than the number of warehouses. This value affects the efficiency of load data generation, so it is recommended to be the same as the number of CPU cores of the load generating device.

﻿ ﻿
2.
Set the test script.
Total Transactions per User: The total number of transactions per user. We recommend that you set this parameter to a higher value so as to ensure that the user will not exit due to the completion of transactions during the stress test.
Minutes of Rampup Time: Warm-up time for the stress test.
Minutes for Test Duration: Duration of the stress test.

﻿ ﻿
3.
Set the automated test script.
Minutes per Test in Virtual User Sequence: The interval between two automated test sessions during which the program completes various tasks such as creating virtual users, warming up, running the test, and stopping the test. This value should be greater than the sum of "Minutes of Rampup Time" and "Minutes for Test Duration".
Active Virtual User Sequence (Space Separated): The number of virtual users generated by each iteration of the automated test. It can be understood as the number of concurrent connections.

﻿ ﻿
4.
Select Autopilot > Autopilot in the left pane to start the test.

﻿ ﻿
5.
The test result will be output in the hammerdb.log file.

﻿ ﻿ Test Results Note:
The TPM in HammerDB is obtained through the SQL Server performance counter "batch requests/sec", so the TPM actually refers to the batch requests per minute.
The size of test data set for a instance specification is larger than the memory size of the specification.
Due to potential fluctuations in each stress test, the following results should be considered as references only.
Two-node (Enhanced SSD Cloud Block Storage) Two-node (Enhanced SSD Cloud Block Storage) performance comparison trend chart for each version ﻿ Two-node (Enhanced SSD Cloud Block Storage) TPM performance comparison value for each version Two-node (Enhanced SSD Cloud Block Storage) instance specifications

Number of concurrent connections

2008R2 Enterprise Edition

2012 Enterprise Edition

2014 Enterprise Edition

2016 Enterprise Edition

2017 Enterprise Edition

2019 Enterprise Edition

2022 Enterprise Edition

2-core 4 GB

256

352239

262042

280212

286968

303026

219429

201678

2-core 8 GB

256

377076

288812

311882

304311

332601

263390

255636

2-core 16 GB

256

388685

293021

322642

336443

344545

386888

289641

4-core 8 GB

256

458636

393323

389012

408183

509896

438410

403975

4-core 16 GB

256

540709

409963

410222

423021

642954

514925

419346

4-core 32 GB

256

623564

428425

428862

488802

692582

578395

432027

8-core 16 GB

256

933452

721646

725086

824979

1196618

817838

715547

8-core 32 GB

256

1004120

748527

751189

848024

1294605

893066

758711

8-core 64 GB

256

1159254

806337

801032

866793

1292605

938902

816439

12-core 24 GB

512

1198194

1024785

1166112

1316035

1341090

1203259

1081658

12-core 48 GB

512

1257225

1156326

1242539

1342146

1347441

1246181

1177039

12-core 96 GB

512

1278163

1264625

1262306

1357239

1384425

1339784

1238884

16-core 32 GB

512

1298662

1275058

1323309

1416524

1400905

1507403

1380005

16-core 64 GB

512

1302512

1285033

1382275

1615427

1538581

1573128

1487819

16-core 128 GB

512

1312663

1350118

1452141

1683900

1788873

1599843

1555526

24-core 48 GB

1024

1275539

1538106

1545238

1740442

1884856

2023341

1863752

24-core 96 GB

1024

1287150

1560003

1569981

1831271

1859375

2160272

2020197

24-core 192 GB

1024

1321485

1565067

1577023

1921253

1890143

2217460

2106732

32-core 64 GB

1024

1416006

1562021

1577873

2018539

2179611

2293341

2184033

32-core 128 GB

1024

1533686

1563443

1590213

2138102

2373436

2487950

2331867

32-core 256 GB

1024

1571679

1575837

1612420

2215074

2430662

2680554

2637818

48-core 96 GB

1024

1868288

1614482

1648078

2355156

2419828

2714951

2704403

48-core 192 GB

1024

2117315

1632638

1660248

2398103

2524866

2806729

2778912

48-core 384 GB

1024

2211281

1671979

1688813

2489417

2612611

3137898

2968912

64-core 128 GB

1024

2316704

1821545

1829664

2545152

2653252

3306069

3379483

64-core 256 GB

1024

2357315

1834979

1851950

2694004

2725555

3430230

3481087 Two-node (formerly High Availability Edition - local SSD) Performance comparison of different editions ﻿ TPM comparison of different editions Two-Node (Formerly High Availability Edition) Instance Specification

Concurrent Connections

2008 R2 Enterprise Edition

2012 Enterprise Edition

2014 Enterprise Edition

2016 Enterprise Edition

2017 Enterprise Edition

2019 Enterprise Edition

1-core 2 GB

256

279,798

229,854

261,396

219,142

201,851

181,198

1-core 4 GB

256

284,680

234,401

288,282

222,796

202,510

268,330

1-core 8 GB

256

269,039

236,773

303,002

219,676

208,685

300,385

2-core 16 GB

256

368,366

333,797

446,344

336,843

331,650

390,546

4-core 32 GB

256

657,641

608,801

621,186

665,065

625,370

670,666

8-core 64 GB

256

1,164,062

1,020,500

924,915

1,070,826

1,102,296

1,007,612

12-core 96 GB

1,024

1,348,121

1,266,868

1,153,585

1,337,473

1,325,010

1,367,211

16-core 128 GB

1,024

1,357,678

1,385,158

1,260,322

1,705,660

1,716,818

1,629,583

24-core 192 GB

1,024

1,226,621

1,500,900

1,406,203

2,261,815

1,950,871

2,198,697

32-core 256 GB

1,024

1,401,600

1,526,762

1,462,100

2,280,252

2,520,856

2,771,797

48-core 384 GB

1,024

2,127,159

1,486,582

1,637,912

2,806,496

2,683,302

3,358,182

64-core 512 GB

1,024

2,136,500

1,512,763

1,789,105

2,630,581

2,814,599

3,635,133

90-core 720 GB

1,024

2,205,323

1,602,736

1,813,094

2,948,427

3,391,680

4,579,980 Single-node (formerly Basic Edition - premium cloud disk) Performance comparison of different editions ﻿ TPM comparison of different editions Single-Node (Formerly Basic Edition) Instance Specification

Concurrent Connections

2008 R2 Enterprise Edition

2012 Enterprise Edition

2014 Enterprise Edition

2016 Enterprise Edition

2017 Enterprise Edition

2019 Enterprise Edition

1-core 2 GB

256

271,822

201,348

239,864

155,318

180,204

181,062

1-core 4 GB

256

271,311

224,851

263,445

206,871

218,065

226,523

2-core 4 GB

256

300,573

286,984

349,251

301,520

282,145

280,967

2-core 8 GB

256

343,630

312,184

379,705

315,539

304,840

331,574

4-core 8 GB

256

569,589

557,047

567,886

464,900

457,702

507,047

4-core 16 GB

256

578,367

560,981

602,897

504,379

537,819

592,712

8-core 16 GB MEM

256

968175

977350

866079

705806

812833

871512

8-core 32 GB MEM

256

974293

945406

890642

734445

842877

895221

16-core 32 GB MEM

1024

965995

1033233

1008835

993027

1007447

1056011

16-core 64 GB MEM

1024

1017271

1122514

1064300

1075603

1100160

1147242

24-core 48 GB MEM

1024

912623

1055985

1045071

1129963

1139872

1203012

24-core 96 GB MEM

1024

954747

1061295

1044175

1184654

1147836

1315849 Single-node (formerly Basic Edition - SSD cloud disk) Performance comparison of different editions ﻿ TPM comparison of different editions Single-Node (Formerly Basic Edition) Instance Specification

Concurrent Connections

2008 R2 Enterprise Edition

2012 Enterprise Edition

2014 Enterprise Edition

2016 Enterprise Edition

2017 Enterprise Edition

2019 Enterprise Edition

1-core 2 GB MEM

256

277486

212148

268084

209753

198943

188967

1-core 4 GB MEM

256

287696

230418

261590

210630

207538

236449

2-core 4 GB MEM

256

329331

307056

395540

312891

311241

301509

2-core 8 GB MEM

256

351604

314275

434242

325675

324843

371492

4-core 8 GB MEM

256

582886

574929

585404

550150

464908

551348

4-core 16 GB MEM

256

600462

599149

596735

664131

505928

638924

8-core 16 GB MEM

256

1053565

987506

889740

708025

824114

957938

8-core 32 GB MEM

256

1104104

1009945

903942

767060

892721

995933

16-core 32 GB MEM

1024

1224515

1193629

1118041

1009075

1123299

1088041

16-core 64 GB MEM

1024

1230516

1200651

1136268

1052159

1156376

1081471

24-core 48 GB MEM

1024

1145090

1080964

1099758

1155533

1187867

1269441

24-core 96 GB MEM

1024

1200990

1040499

1108077

1243883

1262611

1377183 ﻿

Previous Topic: Terms of Service Next Topic: Glossary Help and Support

Was this page helpful?

Yes No

You can also Contact sales or Submit a Ticket for help.

Help us improve! Rate your documentation experience in 5 mins.

Start Now On This Page Test Tool Test Environment and Parameters Test instance editions Test instance specifications Load generation environment TPC-C benchmark parameters Number of virtual users Test Method Test Results Two-node (Enhanced SSD Cloud Block Storage) Two-node (formerly High Availability Edition - local SSD) Single-node (formerly Basic Edition - premium cloud disk) Single-node (formerly Basic Edition - SSD cloud disk) Search AllCurrent Product Search titles only Enter keywords to search documentation
