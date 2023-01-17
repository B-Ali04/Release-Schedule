with SPAIDEN as (

    select
        SPRIDEN.SPRIDEN_ID,
        SPRIDEN.SPRIDEN_PIDM,
        SPRIDEN.SPRIDEN_LAST_NAME,
        SPRIDEN.SPRIDEN_FIRST_NAME,
        SPRIDEN.SPRIDEN_MI,
        SPRIDEN.SPRIDEN_NTYP_CODE,
        SPRIDEN.SPRIDEN_CHANGE_IND,
        SPRIDEN.SPRIDEN_SEARCH_LAST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_FIRST_NAME,
        SPRIDEN.SPRIDEN_SEARCH_MI,
        f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') as SPRIDEN_LEGAL_NAME

    from
        SPRIDEN SPRIDEN

    where
        SPRIDEN.SPRIDEN_NTYP_CODE is null
        and SPRIDEN.SPRIDEN_CHANGE_IND is null
   ),

SPAPERS as
(

    select
        SPBPERS.SPBPERS_PIDM as SPBPERS_PIDM,
        SPBPERS.SPBPERS_SSN as SPBPERS_SSN,
        SPBPERS.SPBPERS_BIRTH_DATE as BIRTH_DATE,
        SPBPERS.SPBPERS_SEX as SPBPERS_SEX,
        SPBPERS.SPBPERS_PREF_FIRST_NAME as SPBPERS_PREF_FIRST_NAME,
        SPBPERS.SPBPERS_GNDR_CODE as SPBPERS_GNDR_CODE,
        SPBPERS.SPBPERS_PPRN_CODE as SPBPERS_PPRN_CODE,
        SPBPERS.SPBPERS_BIRTH_DATE as SPBPERS_BIRTH_DATE,
        SPBPERS.SPBPERS_ETHN_CDE as SPBPERS_ETHN_CDE,
        SUBSTR(TO_CHAR(SPBPERS.SPBPERS_BIRTH_DATE,'MM/DD/YYYY'),7,4) as SPBPERS_BIRTH_YEAR,
        case
            when SPBPERS.SPBPERS_CITZ_CODE = 'Y' then 'United States'
            else (select STVNATN_NATION
                 from STVNATN
                 where STVNATN_CODE = nvl(GOBINTL.GOBINTL_NATN_CODE_LEGAL, GOBINTL.GOBINTL_NATN_CODE_BIRTH))
            end as SPBPERS_CITZ_COUNTRY,
        SPBPERS.SPBPERS_CITZ_CODE as SPBPERS_CITZ_CODE,
        SPBPERS.SPBPERS_ETHN_CODE as SPBPERS_ETHN_CODE,
        SPBPERS.SPBPERS_ARMED_SERV_MED_VET_IND as SPBPERS_ARMED_SERV_MED_VET_IND,
        SPBPERS.SPBPERS_VERA_IND as SPBPERS_VERA_IND

   from
        SPBPERS SPBPERS

        left outer join GOBINTL GOBINTL on GOBINTL.GOBINTL_PIDM = SPBPERS.SPBPERS_PIDM
   ),
   
SGASTDN as (

    select
        SGBSTDN.SGBSTDN_PIDM as SGBSTDN_PIDM,
        SGBSTDN.SGBSTDN_TERM_CODE_EFF as SGBSTDN_TERM_CODE_EFF,
        SGBSTDN.SGBSTDN_STST_CODE as SGBSTDN_STST_CODE,
        SGBSTDN.SGBSTDN_LEVL_CODE as SGBSTDN_LEVL_CODE,
        SGBSTDN.SGBSTDN_STYP_CODE as SGBSTDN_STYP_CODE,
        SGBSTDN.SGBSTDN_TERM_CODE_MATRIC as SGBSTDN_TERM_CODE_MATRIC,
        SGBSTDN.SGBSTDN_EXP_GRAD_DATE as SGBSTDN_EXP_GRAD_DATE,
        SGBSTDN.SGBSTDN_DEGC_CODE_1 as SGBSTDN_DEGC_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_1 as SGBSTDN_MAJR_CODE_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1 as SGBSTDN_MAJR_CODE_MINR_1,
        SGBSTDN.SGBSTDN_MAJR_CODE_MINR_1_2 as SGBSTDN_MAJR_CODE_MINR_1_2,
        SGBSTDN.SGBSTDN_MAJR_CODE_CONC_1 as SGBSTDN_MAJR_CODE_CONC_1,
        SGBSTDN.SGBSTDN_RESD_CODE as SGBSTDN_RESD_CODE,
        SGBSTDN.SGBSTDN_ADMT_CODE as SGBSTDN_ADMT_CODE,
        SGBSTDN.SGBSTDN_DEPT_CODE as SGBSTDN_DEPT_CODE,
        SGBSTDN.SGBSTDN_PROGRAM_1 as SGBSTDN_PROGRAM_1,
        f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM, SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF) as SGBSTDN_CLASS_CODE,
        f_Get_desc_fnc('STVSTST', SGBSTDN.SGBSTDN_STST_CODE, 30) as SGBSTDN_STST_DESC,
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
        f_Get_desc_fnc('STVCLAS', f_class_calc_fnc(SGBSTDN.SGBSTDN_PIDM,SGBSTDN.SGBSTDN_LEVL_CODE, SGBSTDN.SGBSTDN_TERM_CODE_EFF), 30) as SGBSTDN_CLASS_DESC

   from
        SGBSTDN SGBSTDN

   where
        SGBSTDN.SGBSTDN_STYP_CODE not in ('X')
        and SGBSTDN.SGBSTDN_MAJR_CODE_1 not in ('0000', 'EHS', 'SUS', 'VIS')
        and SGBSTDN.SGBSTDN_STST_CODE = 'AS'
    ),

SHAGPAR as (

    select

        case
            when SFRTHST.SFRTHST_TMST_CODE is not null then SFRTHST.SFRTHST_TMST_CODE
            when SHRTGPA.SHRTGPA_HOURS_ATTEMPTED >= 12 then 'FT'
                else 'PT'
                end as SFRTHST_ENROLLEMENT,
        SFRTHST.SFRTHST_TERM_CODE as SFRTHST_TERM_CODE,
        SHRTGPA.SHRTGPA_PIDM as SHRTGPA_PIDM,
        SHRTGPA.SHRTGPA_LEVL_CODE as SHRTGPA_LEVL_CODE,
        SHRTGPA.SHRTGPA_GPA_TYPE_IND as SHRTGPA_GPA_TYPE_IND,
        SHRTGPA.SHRTGPA_TERM_CODE as SHRTGPA_TERM_CODE,
        SHRTGPA.SHRTGPA_HOURS_ATTEMPTED as SHRTGPA_HOURS_ATTEMPTED,
        SHRTGPA.SHRTGPA_HOURS_EARNED as SHRTGPA_HOURS_EARNED,
        SHRTGPA.SHRTGPA_GPA_HOURS as SHRTGPA_GPA_HOURS,
        SHRTGPA.SHRTGPA_GPA as SHRTGPA_GPA,
        SHRTGPA.SHRTGPA_QUALITY_POINTS as SHRTGPA_QUALITY_POINTS,
        SHRTGPA.SHRTGPA_HOURS_PASSED as SHRTGPA_HOURS_PASSED,
        SHRLGPA.SHRLGPA_PIDM as SHRLGPA_PIDM,
        SHRLGPA.SHRLGPA_LEVL_CODE as SHRLGPA_LEVL_CODE,
        SHRLGPA.SHRLGPA_GPA_TYPE_IND as SHRLGPA_GPA_TYPE_IND,
        SHRLGPA.SHRLGPA_HOURS_ATTEMPTED as SHRLGPA_HOURS_ATTEMPTED,
        SHRLGPA.SHRLGPA_HOURS_EARNED as SHRLGPA_HOURS_EARNED,
        SHRLGPA.SHRLGPA_GPA_HOURS as SHRLGPA_GPA_HOURS,
        SHRLGPA.SHRLGPA_GPA as SHRLGPA_GPA,
        SHRLGPA.SHRLGPA_QUALITY_POINTS as SHRLGPA_QUALITY_POINTS,
        trunc(SHRTGPA.SHRTGPA_GPA,3) as SHRTGPA_SEMESTER_GPA,
        trunc(SHRLGPA.SHRLGPA_GPA,3) as SHRLGPA_CUMULATIVE_GPA

    from
        SHRTGPA SHRTGPA

        left outer join SHRLGPA SHRLGPA on SHRLGPA.SHRLGPA_PIDM = SHRTGPA.SHRTGPA_PIDM
            --and SHRLGPA.SHRLGPA_GPA_TYPE_IND = 'I'
            and SHRLGPA.SHRLGPA_LEVL_CODE = SHRTGPA.SHRTGPA_LEVL_CODE
        left outer join SFRTHST SFRTHST on SFRTHST.SFRTHST_PIDM = SHRTGPA.SHRTGPA_PIDM
            and SFRTHST.SFRTHST_TERM_CODE = SHRTGPA.SHRTGPA_TERM_CODE
            and SFRTHST.SFRTHST_SURROGATE_ID = (select max(SFRTHST_SURROGATE_ID)
                                               from SFRTHST SFRTHSTX
                                               where SFRTHSTX.SFRTHST_PIDM = SFRTHST.SFRTHST_PIDM
                                               and SFRTHSTX.SFRTHST_TERM_CODE = SFRTHST.SFRTHST_TERM_CODE)

    where
        SHRTGPA.SHRTGPA_GPA_TYPE_IND = 'I'
    )
    
select 
stvterm_desc as semester,
f_format_name(SPRIDEN.SPRIDEN_PIDM, 'LFMI') as lfmi_name, 

spbpers_pref_first_name as pref_fname, spriden_id as BannerID, shrlgpa_gpa, shrlgpa_hours_attempted, shrlgpa_gpa_hours, sgbstdn_levl_code as levl_code,
sgbstdn_degc_code_1
as degc_code, shrlgpa_pidm

from 
stvterm stvterm
left outer join spaiden spriden on spriden_pidm is not null
left outer join SGASTDN SGBSTDN on SGBSTDN.SGBSTDN_PIDM = SPRIDEN.SPRIDEN_PIDM
     and SGBSTDN_TERM_CODE_EFF = fy_sgbstdn_eff_term(SGBSTDN_PIDM, STVTERM_CODE)

left outer join shagpar shrtgpa on shrlgpa_pidm = spriden_pidm
     and shrlgpa_gpa_type_ind = 'O'
     and shrlgpa_levl_code = 'GR'
     and shrtgpa_term_code = sgbstdn_term_code_Eff

left outer join spapers on spbpers_pidm = spriden_pidm

where 
stvterm_code = '&g'
and spriden_change_ind is null 
and spriden_ntyp_code is null
and sgbstdn_levl_code = 'GR'
and f_registered_this_term(SPRIDEN_PIDM, STVTERM_CODE) = 'Y'
--and spriden_id = 'F00179728'
and ((shrlgpa_gpa < 3.00 and shrlgpa_levl_code = 'GR')
--select * from sfrstcr 
or exists (select 1 from sfrstcr r where r.sfrstcr_pidm = shrlgpa_pidm and r.sfrstcr_rsts_code = 'RE' and SFRSTCR_LEVL_CODE = 'GR' and r.sfrstcr_term_code = '&g')
and (select count(*) from shrtckg g where g.shrtckg_pidm = shrlgpa_pidm and g.shrtckg_grde_code_final in ('U','IU') and g.shrtckg_seq_no = (select max(g2.shrtckg_seq_no) from shrtckg g2 where g2.shrtckg_pidm = g.shrtckg_pidm and g2.shrtckg_term_code = g.shrtckg_term_code and g2.shrtckg_tckn_seq_no = g.shrtckg_tckn_seq_no)) >= 2
)
