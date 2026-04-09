INSERT INTO public.user_info VALUES ('chris', '인선미', '9512121212121', 'SK','01077777777');

INSERT INTO public.user_info VALUES ('chris2', '인선미', '951212121212', 'SK','01077777777');

INSERT INTO public.arrival VALUES ('chris', '집', '경기도 안양시');

INSERT INTO public.arrival VALUES ('rm', '집', '경기도 일산');

INSERT INTO public.arrival VALUES ('jimin', '경기도 일산');


CREATE TABLE public.user_info (
	user_id varchar(10) NOT NULL,
	user_name varchar(10) NOT NULL,
	jumin_no bpchar(13) NOT NULL,
	tel_co bpchar(2) NOT NULL,
	tel_no bpchar(11) NOT NULL,
	CONSTRAINT user_info_check CHECK ((length(jumin_no) = 13)),
	CONSTRAINT user_info_pk PRIMARY KEY (user_id)
);


