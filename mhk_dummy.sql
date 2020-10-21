CREATE TABLE if not exists title
(
    id                 bigint(20)   not null auto_increment,
    creation_timestamp int(11)      not null,
    title              varchar(255) not null,
    genre_id           bigint(20)   not null,
    primary key (id),
    index fk_title_to_genre (genre_id)
);

CREATE TABLE if not exists genre
(
    id   bigint(20)   not null auto_increment,
    name varchar(255) not null,
    primary key (id)
);

INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (1, 1583215147, '보다', 1);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (2, 1586231917, '가슴으로 들어요', 1);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (3, 1592356793, '유진의 환상특급열차 vol.1', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (4, 1572506127, '나사들의 이야기', 1);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (5, 1591062026, '매일 한 칸씩', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (6, 1565932124, '안녕안녕해', 7);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (7, 1594798587, '조선롹스타', 3);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (8, 1595826338, '나의 연애 D-day', 6);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (9, 1596174780, '그때, 우리가 있었던 계절', 6);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (10, 1565932588, '홈리스 탐정', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (11, 1565931012, '사랑을 너에게', 3);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (12, 1575529855, '그림을 그리는 일', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (13, 1567572438, '눈맞춤', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (14, 1596502543, '직장인 감자', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (15, 1592899987, '하루의 끝을 당신과', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (16, 1577756415, '꿈의 반려', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (17, 1596174471, '환상여행', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (18, 1565930890, 'My Killer', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (19, 1586420909, '어느 날, 문득', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (20, 1589848359, 'Return', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (21, 1596503100, '이웃집 남녀 in 교토', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (22, 1565932023, '안녕 이바, 안녕 나의 고양이', 6);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (23, 1582594323, '가가바이러스', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (24, 1588132698, '뿌리네 이야기', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (25, 1596502687, '낭만도시', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (26, 1597107090, '오목왕', 1);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (27, 1565931645, '개구리공주', 1);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (28, 1596502313, '오늘을 살아본 게 아니잖아', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (29, 1596174213, '화초 죽이기', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (30, 1577762836, '꼬꼬댁 대소동', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (31, 1595481810, '좋은 남편', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (32, 1596676612, '그리고 또', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (33, 1591167401, '별이 내린 여름날', 3);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (34, 1585544839, '은퇴 요리사', 1);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (35, 1569996164, '페어리링', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (36, 1580799734, 'Winter Game', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (37, 1594259547, '만화경 편집부는 9층입니다', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (38, 1585735155, '섬의 봄', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (39, 1565932210, '매화꽃이 피었나이다', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (40, 1596174617, '곁에', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (41, 1565932381, '고냥 일기', 6);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (42, 1589324292, '별일 없이 산다', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (43, 1565931513, '오픈했어요 매직컬 마카롱', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (44, 1565932311, '결혼교과시간', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (45, 1565932487, '회사원 채대리', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (46, 1565931728, '너의 행성 B126으로', 5);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (47, 1565931151, '종이비행기를 날리면', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (48, 1565931279, '논스톱 서브웨이', 1);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (49, 1581415180, '오버사이즈 러브', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (50, 1584434163, '나는 슬기', 4);

INSERT INTO genre(id, name)
VALUES (1, '유머');
INSERT INTO genre(id, name)
VALUES (2, '판타지');
INSERT INTO genre(id, name)
VALUES (3, '로맨스');
INSERT INTO genre(id, name)
VALUES (4, '스토리');
INSERT INTO genre(id, name)
VALUES (5, '드라마');
INSERT INTO genre(id, name)
VALUES (6, '일상');

-- 데이터 추가용 쿼리
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (51, 1588587750, '요괴 뚝딱 한끼 뚝딱', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (52, 1596097835, '동네 한 바퀴', 2);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (53, 1596175162, '다름이 아니라', 3);
INSERT INTO title(id, creation_timestamp, title, genre_id)
VALUES (54, 1584594563, '윌슨가의 비밀', 2);
