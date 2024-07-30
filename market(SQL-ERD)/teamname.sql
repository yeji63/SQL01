use teamname;

CREATE TABLE member (
    memberid VARCHAR(15) NOT NULL,
    password VARCHAR(300) NULL,
    membername VARCHAR(20) NULL,
    gender CHAR(1) NULL,
    age INT NULL,
    email VARCHAR(30) NULL,
    phone CHAR(11) NULL,
    grade VARCHAR(15) NULL,
    enrolldate DATE NULL,
    CONSTRAINT PK_MEMBER PRIMARY KEY (memberid)
);

CREATE TABLE product (
    pID VARCHAR(30) NOT NULL,
    orderno INT NOT NULL,
    memberid VARCHAR(15) NOT NULL,
    pname VARCHAR(30) NULL,
    pprice INT NULL,
    pcategory VARCHAR(30) NULL,
    description VARCHAR(50) NULL,
    pstock INT NULL,
    CONSTRAINT PK_PRODUCT PRIMARY KEY (pID, orderno, memberid),
    CONSTRAINT FK_order_TO_product_1 FOREIGN KEY (orderno) REFERENCES orders (orderno),
    CONSTRAINT FK_order_TO_product_2 FOREIGN KEY (memberid) REFERENCES orders (memberid)
);

CREATE TABLE b_review (
    b_no INT NOT NULL,
    orderno INT NOT NULL,
    memberid VARCHAR(15) NOT NULL,
    b_writer VARCHAR(15) NULL,
    b_content VARCHAR(2000) NULL,
    b_original_filename VARCHAR(100) NULL,
    b_renamed_filename VARCHAR(100) NULL,
    b_date DATE NULL,
    CONSTRAINT PK_B_REVIEW PRIMARY KEY (b_no, orderno, memberid),
    CONSTRAINT FK_order_TO_b_review_1 FOREIGN KEY (orderno) REFERENCES orders (orderno),
    CONSTRAINT FK_order_TO_b_review_2 FOREIGN KEY (memberid) REFERENCES orders (memberid)
);

CREATE TABLE orders (
    orderno INT NOT NULL,
    memberid VARCHAR(15) NOT NULL,
    res_name VARCHAR(20) NULL,
    res_address VARCHAR(100) NULL,
    res_phone CHAR(11) NULL,
    res_requirement VARCHAR(100) NULL,
    totalprice INT NULL,
    orderdate DATE NULL,
    CONSTRAINT PK_ORDER PRIMARY KEY (orderno, memberid),
    CONSTRAINT FK_member_TO_order_1 FOREIGN KEY (memberid) REFERENCES member (memberid)
);

CREATE TABLE cart (
    memberid VARCHAR(15) NOT NULL,
    pID VARCHAR(30) NOT NULL,
    amount INT NULL,
    pprice INT NULL,
    CONSTRAINT PK_CART PRIMARY KEY (memberid, pID),
    CONSTRAINT FK_member_TO_cart_1 FOREIGN KEY (memberid) REFERENCES member (memberid),
    CONSTRAINT FK_product_TO_cart_1 FOREIGN KEY (pID) REFERENCES product (pID)
);

CREATE TABLE delete_b_review (
    b_no INT NOT NULL,
    orderno INT NOT NULL,
    memberid VARCHAR(15) NOT NULL,
    b_writer VARCHAR(15) NULL,
    b_content VARCHAR(2000) NULL,
    b_original_filename VARCHAR(100) NULL,
    b_renamed_filename VARCHAR(100) NULL,
    b_date DATE NULL
);

DROP TABLE delete_b_review;


-- 데이터
INSERT INTO member (memberid, password, membername, gender, age, email, phone, grade, enrolldate)
VALUES 
('M001', 'password1', '영희', 'F', 28, 'younghee@example.com', '01012345678', '골드', STR_TO_DATE('2023-01-15', '%Y-%m-%d')),
('M002', 'password2', '철수', 'M', 32, 'chulsoo@example.com', '01012345679', '실버', STR_TO_DATE('2023-02-20', '%Y-%m-%d')),
('M003', 'password3', '영훈', 'M', 25, 'younghoon@example.com', '01012345680', '브론즈', STR_TO_DATE('2023-03-10', '%Y-%m-%d'));

INSERT INTO orders (orderno, memberid, res_name, res_address, res_phone, res_requirement, totalprice, orderdate)
VALUES 
(101, 'M001', '영희', '서울시 강남구', '01012345678', '없음', 10050, STR_TO_DATE('2023-04-01', '%Y-%m-%d')),
(102, 'M002', '철수', '서울시 서초구', '01012345679', '선물 포장', 20075, STR_TO_DATE('2023-04-02', '%Y-%m-%d')),
(103, 'M003', '영훈', '서울시 송파구', '01012345680', '긴급', 15000, STR_TO_DATE('2023-04-03', '%Y-%m-%d'));


INSERT INTO b_review (b_no, orderno, memberid, b_writer, b_content, b_original_filename, b_renamed_filename, b_date)
VALUES 
(1, 101, 'M001', '영희', '좋은 제품입니다!', 'original1.jpg', 'renamed1.jpg', STR_TO_DATE('2023-04-01', '%Y-%m-%d')),
(2, 102, 'M002', '철수', '괜찮아요.', 'original2.jpg', 'renamed2.jpg', STR_TO_DATE('2023-04-02', '%Y-%m-%d')),
(3, 103, 'M003', '영훈', '좀 더 나았으면 좋겠어요.', 'original3.jpg', 'renamed3.jpg', STR_TO_DATE('2023-04-03', '%Y-%m-%d'));

INSERT INTO product (pID, orderno, memberid, pname, pprice, pcategory, description, pstock)
VALUES 
('P001', 101, 'M001', '제품1', 10050, '카테고리1', '설명1', 50),
('P002', 102, 'M002', '제품2', 20075, '카테고리2', '설명2', 30),
('P003', 103, 'M003', '제품3', 15000, '카테고리3', '설명3', 20);

INSERT INTO cart (memberid, pID, amount, pprice)
VALUES 
('M001', 'P001', 2, 10050),
('M002', 'P002', 1, 20075),
('M003', 'P003', 3, 15000);


-- INSERT INTO delete_b_review (b_no, orderno, memberid, b_writer, b_content, b_original_filename, b_renamed_filename, b_date)
-- VALUES 
-- (1, 101, 'M001', '영희', '삭제된 리뷰 1', 'del_original1.jpg', 'del_renamed1.jpg', TO_DATE('2023-05-01', 'YYYY-MM-DD')),
-- (2, 102, 'M002', '철수', '삭제된 리뷰 2', 'del_original2.jpg', 'del_renamed2.jpg', TO_DATE('2023-05-02', 'YYYY-MM-DD')),
-- (3, 103, 'M003', '영훈', '삭제된 리뷰 3', 'del_original3.jpg', 'del_renamed3.jpg', TO_DATE('2023-05-03', 'YYYY-MM-DD'));


DROP TRIGGER IF EXISTS b_review_delete_trigger;

DELIMITER // 
CREATE TRIGGER b_review_delete_trigger  -- 트리거 이름
    AFTER DELETE -- 삭제 후에 작동하도록 지정
    ON b_review -- 트리거를 부착할 테이블
    FOR EACH ROW -- 각 행마다 적용시킴
BEGIN
    INSERT INTO delete_b_review (b_no, orderno, memberid, b_writer, b_content, b_original_filename, b_renamed_filename, b_date)
    VALUES (OLD.b_no, OLD.orderno, OLD.memberid, OLD.b_writer, '주문 정보가 삭제됨', OLD.b_original_filename, OLD.b_renamed_filename, OLD.b_date);
END // 
DELIMITER ;

DELETE FROM b_review WHERE b_no=3;

SELECT * FROM delete_b_review;