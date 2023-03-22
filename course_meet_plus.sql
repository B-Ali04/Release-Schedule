/*
instructino meettimes/
class schedules.
*/
--SELECT * FROM SFRSTCR WHERE SFRSTCR_TERM_CODE = 202240 AND SFRSTCR_RSTS_CODE = 'RE'
with SPAIDEN as
(
    SELECT
        SPRIDEN.SPRIDEN_ID as SPRIDEN_ID,
        SPRIDEN.SPRIDEN_PIDM as SPRIDEN_PIDM,
        SPRIDEN.SPRIDEN_LAST_NAME as SPRIDEN_LAST_NAME,
        SPRIDEN.SPRIDEN_FIRST_NAME as SPRIDEN_FIRST_NAME,
        SPRIDEN.SPRIDEN_MI as SPRIDEN_MI,
        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME as SPRIDEN_SEARCH_LAST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME as SPRIDEN_SEARCH_FIRST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_MI as SPRIDEN_SEARCH_MI,
        f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') as SPRIDEN_LEGAL_NAME

    FROM
        SPRIDEN SPRIDEN

    WHERE
        SPRIDEN_NTYP_CODE IS NULL
        AND SPRIDEN_CHANGE_IND IS NULL
    ),

SOREMAL as
(
    select
        GOREMAL.GOREMAL_PIDM,
        GOREMAL.GOREMAL_EMAL_CODE,
        GOREMAL.GOREMAL_EMAIL_ADDRESS,
        GOREMAL.GOREMAL_STATUS_IND,
        GOREMAL.GOREMAL_PREFERRED_IND,
        GORADID.GORADID_PIDM,
        GORADID.GORADID_ADDITIONAL_ID,
        GORADID.GORADID_ADID_CODE,
        GOBTPAC_EXTERNAL_USER --esfid

    FROM
        GOREMAL GOREMAL

        LEFT OUTER JOIN GORADID GORADID ON GORADID.GORADID_PIDM = GOREMAL.GOREMAL_PIDM
        LEFT OUTER JOIN GOBUMAP GOBUMAP ON GOBUMAP.GOBUMAP_PIDM = GOREMAL.GOREMAL_PIDM
        LEFT OUTER JOIN GOBTPAC GOBTPAC ON GOBTPAC.GOBTPAC_PIDM = GOREMAL.GOREMAL_PIDM

    WHERE
        GOREMAL.GOREMAL_EMAL_CODE = 'SU'
        AND GOREMAL.GOREMAL_STATUS_IND = 'A'
        AND GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        AND GORADID.GORADID_ADID_CODE = 'SUID'
    ),

SIRASGQ AS(
    select
        SIRASGN.SIRASGN_PIDM,
        SIRDPCL.SIRDPCL_PIDM,
        f_format_name(SIRDPCL_PIDM, 'LF30') as SIRDPCL_NAME,
        case
          when SIRDPCL_DEPT_CODE is null then f_get_desc_fnc('STVDEPT', SCBCRSE_DEPT_CODE, 30)
            else f_get_desc_fnc('STVDEPT', SIRDPCL_DEPT_CODE, 30)
              end as SIRDPCL_DEPT_DESC,
        SIRASGN_PRIMARY_IND as Primary_Instr,
        SSBSECT_TERM_CODE as Term_Code,
        SSBSECT_SICAS_CAMP_COURSE_ID as COURSE_ID,
        SSBSECT_CRN,
        SSBSECT_PTRM_CODE,
        SSBSECT_SUBJ_CODE,
        SSBSECT_CRSE_NUMB,
        SSBSECT_SEQ_NUMB,
        SSBSECT_ENRL,
        SSBSECT_SEATS_AVAIL,
        SSBSECT_TOT_CREDIT_HRS,
        GOREMAL_EMAIL_ADDRESS

    FROM
        SSBSECT SSBSECT
        LEFT OUTER JOIN SIRASGN SIRASGN ON SIRASGN_TERM_CODE = SSBSECT_TERM_CODE
             AND SIRASGN.SIRASGN_CRN = SSBSECT.SSBSECT_CRN
             AND SIRASGN_PRIMARY_IND = 'Y'
        LEFT OUTER JOIN SIRDPCL SIRDPCL ON SIRDPCL_PIDM = SIRASGN_PIDM
             AND SIRDPCL_SURROGATE_ID = (SELECT MAX(SIRDPCL_SURROGATE_ID)
                                        FROM SIRDPCL X
                                        WHERE X.SIRDPCL_PIDM = SIRDPCL.SIRDPCL_PIDM)
        LEFT OUTER JOIN GOREMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SIRDPCL_PIDM
             AND GOREMAL.GOREMAL_EMAL_CODE = 'ESF'
             AND GOREMAL.GOREMAL_STATUS_IND = 'A'
             AND GOREMAL.GOREMAL_PREFERRED_IND = 'Y'
        LEFT OUTER JOIN SCBCRSE SCBCRSE ON SSBSECT_SUBJ_CODE = SCBCRSE.SCBCRSE_SUBJ_CODE
            and SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT_CRSE_NUMB

    WHERE
        SSBSECT_TERM_CODE = '&T'
        AND SIRDPCL_DEPT_CODE <> 'SU'
    ),

SGASTDN as
(
    select
        SGBSTDN.SGBSTDN_PIDM as SGBSTDN_PIDM,
        SGBSTDN.SGBSTDN_TERM_CODE_EFF as SGBSTDN_TERM_CODE_EFF,
        SGBSTDN.SGBSTDN_STST_CODE as SGBSTDN_STST_CODE,
        SGBSTDN.SGBSTDN_LEVL_CODE as SGBSTDN_LEVL_CODE,
        SGBSTDN.SGBSTDN_STYP_CODE as SGBSTDN_STYP_CODE,
        SGBSTDN.SGBSTDN_TERM_CODE_MATRIC as SGBSTDN_TERM_CODE_MATRIC,
        SGBSTDN.SGBSTDN_TERM_CODE_ADMIT as SGBSTDN_TERM_CODE_ADMIT,
        SGBSTDN.SGBSTDN_EXP_GRAD_DATE as SGBSTDN_EXP_GRAD_DATE,
        SGBSTDN.SGBSTDN_CAMP_CODE as SGBSTDN_CAMP_CODE,
        SGBSTDN.SGBSTDN_COLL_CODE_1 as SGBSTDN_COLL_CODE_1,
        SGBSTDN.SGBSTDN_DEGC_CODE_1 as SGBSTDN_DEGC_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_1 as SGBSTDN_MAJR_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1 as SGBSTDN_MAJR_CODE_MINR_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2 as SGBSTDN_MAJR_CODE_MINR_1_2,
        SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1 as SGBSTDN_MAJR_CODE_CONC_1,
        SGBSTDN.SGBSTDN_RESD_CODE as SGBSTDN_RESD_CODE,
        SGBSTDN.SGBSTDN_ADMT_CODE as SGBSTDN_ADMT_CODE,
        SGBSTDN.SGBSTDN_DEPT_CODE as SGBSTDN_DEPT_CODE,
        SGBSTDN.SGBSTDN_PROGRAM_1 as SGBSTDN_PROGRAM_1,
        SGBSTDN.SGBSTDN_TERM_CODE_GRAD as SGBSTDN_TERM_CODE_GRAD,
        SGBSTDN.SGBSTDN_ACTIVITY_DATE as SGBSTDN_ACTIVITY_DATE,
        f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM, SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF) as SGBSTDN_CLAS_CODE,
        f_Get_desc_fnc('STVSTST',SGBSTDN.SGBSTDN_STST_CODE, 30) as SGBSTDN_STST_DESC,
        f_Get_desc_fnc('STVLEVL', SGBSTDN.SGBSTDN_LEVL_CODE, 30) as SGBSTDN_LEVL_DESC,
        f_Get_desc_fnc('STVSTYP', SGBSTDN.SGBSTDN_STYP_CODE, 30) as SGBSTDN_STYP_DESC,
        f_Get_desc_fnc('STVDEGC', SGBSTDN.SGBSTDN_DEGC_CODE_1, 30) as SGBSTDN_DEGC_DESC,
        f_Get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_1, 30) as SGBSTDN_MAJR_DESC,
        f_Get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1, 30) as SGBSTDN_MINR_1_DESC,
        f_Get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2, 30) as SGBSTDN_MINR_1_2_DESC,
        f_Get_desc_fnc('STVMAJR', SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1, 30) as SGBSTDN_CONC_DESC,
        f_Get_desc_fnc('STVRESD', SGBSTDN.SGBSTDN_RESD_CODE, 30) as SGBSTDN_RESD_DESC,
        f_Get_desc_fnc('STVADMT', SGBSTDN.SGBSTDN_ADMT_CODE, 30) as SGBSTDN_ADMT_DESC,
        f_Get_desc_fnc('STVDEPT', SGBSTDN.SGBSTDN_DEPT_CODE, 30) as SGBSTDN_DEPT_DESC,
        f_Get_desc_fnc('STVTERM', SGBSTDN.SGBSTDN_TERM_CODE_MATRIC, 30) as SGBSTDN_MATRIC_TERM_DESC,
        f_Get_desc_fnc('STVTERM', SGBSTDN.SGBSTDN_TERM_CODE_GRAD, 30) as SGBSTDN_GRAD_TERM_DESC,
        f_Get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF), 30) as SGBSTDN_CLAS_DESC

   from
        SGBSTDN SGBSTDN
   ),

SFAREGS AS (
    select
        SFRSTCR_PIDM,
        CASE
          WHEN SFRSTCR_PIDM IS NULL THEN NULL
            ELSE f_format_name(SFRSTCR_PIDM, 'LF30')
              END as STUDENT,-- SFRSTCR_NAME,
        SSBSECT_TERM_CODE as Term_Code,
        SSBSECT_SICAS_CAMP_COURSE_ID as COURSE_ID,
        SSBSECT_CRN,
        SSBSECT_PTRM_CODE,
        SSBSECT_SUBJ_CODE,
        SSBSECT_CRSE_NUMB,
        SSBSECT_SEQ_NUMB,
        SSBSECT_ENRL,
        SSBSECT_SEATS_AVAIL,
        SSBSECT_TOT_CREDIT_HRS,
        GOREMAL_EMAIL_ADDRESS as ESF_EMAIL_ADDRESS

    FROM
        SSBSECT SSBSECT

        LEFT OUTER JOIN SCBCRSE SCBCRSE ON SSBSECT_SUBJ_CODE = SCBCRSE.SCBCRSE_SUBJ_CODE
             AND SCBCRSE.SCBCRSE_CRSE_NUMB = SSBSECT_CRSE_NUMB
        LEFT OUTER JOIN SFRSTCR SFRSTCR ON SFRSTCR_TERM_CODE = SSBSECT_TERM_CODE
             AND SFRSTCR.SFRSTCR_CRN = SSBSECT_CRN
        LEFT OUTER JOIN GOREMAL GOREMAL ON GOREMAL.GOREMAL_PIDM = SFRSTCR.SFRSTCR_PIDM
             AND GOREMAL.GOREMAL_EMAL_CODE = 'SU'
             AND GOREMAL.GOREMAL_STATUS_IND = 'A'
    WHERE
        SSBSECT_TERM_CODE = '&T'
        AND SFRSTCR.SFRSTCR_RSTS_CODE IN ('RE', 'RW')
),

VIEW_1 AS
(
    select
        SIRDPCL_DEPT_DESC,
        Primary_Instr,
        SIRDPCL_NAME aS instructor_name,
        S.GOREMAL_EMAIL_ADDRESS,
        S.Term_Code,
        S.COURSE_ID,
        --SFRSTCR_NAME,
        S.SSBSECT_CRN,
        S.SSBSECT_PTRM_CODE,
        S.SSBSECT_SUBJ_CODE,
        S.SSBSECT_CRSE_NUMB,
        S.SSBSECT_SEQ_NUMB,
        S.SSBSECT_ENRL,
        S.SSBSECT_SEATS_AVAIL,
        S.SSBSECT_TOT_CREDIT_HRS,
        STUDENT,
        SGBSTDN_CLAS_CODE AS CLAS_CODE,
        SGBSTDN_CLAS_DESC AS CLAS_DESC,
        SGBSTDN_STST_CODE AS STST_CODE,
        SGBSTDN_STST_DESC AS STST_DESC,
        SGBSTDN_LEVL_CODE AS CLAS_LEVL_CODE,
        SGBSTDN_LEVL_DESC AS CLAS_LEVL_DESC,
        SGBSTDN_STYP_CODE AS STYP_CODE,
        SGBSTDN_STYP_DESC AS STYP_DESC

    FROM
        SIRASGQ S
        LEFT OUTER JOIN SFAREGS SR ON SR.COURSE_ID = S.COURSE_ID AND SR.TERM_CODE = S.TERM_CODE AND SR.SSBSECT_CRN = S.SSBSECT_CRN
        LEFT OUTER JOIN SGASTDN SGBSTDN ON SGBSTDN.SGBSTDN_PIDM = SR.SFRSTCR_PIDM
             AND SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN.SGBSTDN_PIDM, S.TERM_CODE)
             AND SGBSTDN_STST_CODE = 'AS'

ORDER BY
      COURSE_ID

)

SELECT V1.* FROM VIEW_1 V1

ORDER BY
        instructor_name, V1.COURSE_ID, STUDENT --S.SFRSTCR_NAME
