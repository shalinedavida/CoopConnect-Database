

CREATE SCHEMA coopconnect;


CREATE TABLE coopconnect.farmers(
farmer_id INT PRIMARY KEY,
name VARCHAR(100) NOT NULL,
coop_id VARCHAR(50) UNIQUE NOT NULL,
Phone_number VARCHAR(20) UNIQUE NOT NULL,
village_id  VARCHAR(20) UNIQUE NOT NULL
);


INSERT INTO coopconnect.farmers(farmer_id, name, coop_id, phone_number, village_id) VALUES
('1','John James', 'COOP001', '+254712345678', 'VILLAGE01'),
('2','Jane Smith', 'COOP002', '+254787654321', 'VILLAGE02'),
('3','Michael Johnson', 'COOP003', '+254700112233', 'VILLAGE03'),
('4','Abel Brown', 'COOP004', '+254733445566', 'VILLAGE04'),
('5','Charlie Davis', 'COOP005', '+254722998877', 'VILLAGE05'),
('6','Brhanu White', 'COOP006', '+254755667788', 'VILLAGE06');


SELECT * FROM coopconnect.farmers




CREATE TABLE  coopconnect.training_sessions(
session_id INT PRIMARY KEY,
topic VARCHAR(500) NOT NULL,
date DATE NOT NULL,
village VARCHAR(255) NOT NULL,
extension_worker VARCHAR(255) NOT NULL
);
INSERT INTO coopconnect.training_sessions( session_id,topic, date, village, extension_worker) VALUES
('1','Soil Health Management', '2025-04-10', 'VILLAGE01', 'John Kariuki'),
('2','Crop Rotation Techniques', '2025-04-12', 'VILLAGE02', 'Alice Wambua'),
('3','Pest Control Strategies', '2025-04-15', 'VILLAGE03', 'David Omondi'),
('4','Organic Farming Practices', '2025-04-18', 'VILLAGE04', 'Grace Achieng'),
('5','Irrigation Systems Overview', '2025-04-20', 'VILLAGE05', 'Peter Mwangi'),
('6','Post-Harvest Handling', '2025-04-22', 'VILLAGE06', 'Lucy Njeri');




SELECT * FROM coopconnect.training_sessions




CREATE TABLE coopconnect.attendance(
attendance_id INT PRIMARY KEY,
farmer_id  INT NOT NULL,
session_id INT NOT NULL,
date DATE NOT NULL ,
village_id VARCHAR(20) NOT NULL,
attended_at TIMESTAMPTZ DEFAULT NOW(),
FOREIGN KEY (farmer_id)REFERENCES coopconnect.farmers(farmer_id) ON DELETE CASCADE,
FOREIGN KEY (session_id) REFERENCES coopconnect.training_sessions(id) ON DELETE CASCADE
);


INSERT INTO coopconnect.attendance(attendance_id,farmer_id,session_id,date, village_id) VALUES
(1,1, 1,'2025-04-10', 'VILLAGE01'),
(2,2, 2,'2025-04-10', 'VILLAGE02'),
(3,3, 1,'2025-04-10', 'VILLAGE03'),
(4,4, 3,'2025-04-10', 'VILLAGE04'),
(5,5, 2,'2025-04-10', 'VILLAGE05'),
(6,6, 3, '2025-04-10','VILLAGE06');


SELECT * FROM coopconnect.attendance


CREATE TABLE   coopconnect.farmer_rewards(
reward_id INT  PRIMARY KEY,
farmer_id INT NOT NULL,
attendance_id  INT NOT NULL,
farmer_points INT NOT NULL DEFAULT 0,
status VARCHAR(20) NOT NULL ,
last_updated TIMESTAMPTZ NOT NULL DEFAULT  NOW(),
FOREIGN KEY (farmer_id) REFERENCES coopconnect.farmers(id) ON DELETE CASCADE,
FOREIGN  KEY (attendance_id) REFERENCES coopconnect.attendance(id) ON DELETE CASCADE
);


INSERT INTO coopconnect.farmer_rewards(reward_id,farmer_id, attendance_id, farmer_points, status)
VALUES
(1,1, 1, 50, 'Active'),
(2,2, 2, 30, 'Inactive'),
(3,3, 3, 70, 'Active'),
(4,4, 4, 20, 'Pending'),
(5,5, 5, 90, 'Active'),
(6,6, 6, 40, 'Suspended');




SELECT * FROM coopconnect.farmer_rewards




CREATE TABLE coopconnect.payments(
payment_id INT PRIMARY KEY,
farmer_id INT NOT NULL,
session_id INT NOT NULL,
amount DECIMAL(10,2) NOT NULL,
payment_method VARCHAR (255) NOT NULL,
status VARCHAR (255) NOT NULL,
transaction_id VARCHAR(50) UNIQUE NOT NULL,
points_deducted INT DEFAULT 0,
created_at TIMESTAMPTZ NOT NULL  DEFAULT NOW(),
FOREIGN KEY (farmer_id) REFERENCES  coopconnect.farmers(farmer_id) ON DELETE CASCADE ,
FOREIGN KEY (session_id) REFERENCES coopconnect.training_sessions(session_id) ON DELETE CASCADE
);




SELECT * FROM coopconnect.payments


ALTER TABLE coopconnect.payments
RENAME COLUMN id to payment_id;


INSERT INTO coopconnect.payments(
   payment_id,
   farmer_id,
   session_id,
   amount,
   payment_method,
   status,
   transaction_id,
   points_deducted
);
VALUES
(16,'1','1', 500.00, 'MTN Money', 'Completed', 'TXN20250401001', 0),
(22,'2','2', 300.00, 'Reward Points', 'Pending', 'TXN20250401002', 50),
(36,'3','3', 450.00, 'MTN Money', 'Completed', 'TXN20250401003', 0),
(49,'4','4', 200.00, 'Reward Points', 'Failed', 'TXN20250401004', 20),
(58,'5','5', 600.00, 'MTN Money', 'Completed', 'TXN20250401005', 0),
(69,'6','6', 350.00, 'Reward Points', 'Pending', 'TXN20250401006', 35);




SELECT * FROM coopconnect.payments


CREATE TABLE coopconnect.payments_history(
id INT PRIMARY KEY,
farmer_id INT NOT NULL,
payment_id INT NOT NULL,
amount DECIMAL(10,2) NOT NULL,
payment_method VARCHAR(255) NOT NULL,
transaction_id VARCHAR(50),
status VARCHAR(255) NOT NULL,
processed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
FOREIGN KEY (farmer_id) REFERENCES  coopconnect.farmers(farmer_id) ON DELETE CASCADE,
FOREIGN KEY (payment_id) REFERENCES coopconnect.payments(payment_id) ON DELETE CASCADE
);


INSERT INTO coopconnect.payments_history (
   id,
   farmer_id,
   payment_id,
   amount,
   payment_method,
   transaction_id,
   status,
   processed_at
);
VALUES
(1,1, 1, 500.00, 'MTN Money', 'TXN20250401001', 'Completed', '2025-04-01 10:10:00'),
(2,2, 2, 300.00, 'Reward Points', 'TXN20250401002', 'Pending', '2025-04-01 10:15:00'),
(3,3, 3, 450.00, 'MTN Money', 'TXN20250401003', 'Completed', '2025-04-01 10:20:00'),
(4,4, 4, 200.00, 'Reward Points', 'TXN20250401004', 'Failed', '2025-04-01 10:25:00'),
(5,5, 5, 600.00, 'MTN Money', 'TXN20250401005', 'Completed', '2025-04-01 10:30:00'),
(6,6, 6, 350.00, 'Reward Points', 'TXN20250401006', 'Pending', '2025-04-01 10:35:00');




SELECT * FROM coopconnect.payments_history


CREATE TABLE coopconnect.users(
coop_id INT PRIMARY  KEY,
full_name VARCHAR(50) UNIQUE NOT NULL,
email VARCHAR(100) UNIQUE NOT NULL,
password VARCHAR(300) NOT NULL,
created_at TIMESTAMPTZ  DEFAULT NOW(),
updated_at TIMESTAMPTZ DEFAULT NOW()
);




INSERT INTO coopconnect.users (coop_id, full_name, email, password) VALUES
(1001, 'John James', 'johndoe@example.com', 'securepassword123'),
(1002, 'Jane Smith', 'janesmith@example.com', 'mypassword456'),
(1003, 'Micheal Johnson', 'alicej@example.com', 'pass1234'),
(1004, 'Abel Brown', 'bobbrown@example.com', 'bobspassword'),
(1005, 'Charlie Davis', 'charlied@example.com', 'letmein'),
(1006, 'Brhanu White', 'evewhite@example.com', 'evepassword');




SELECT * FROM coopconnect.users





