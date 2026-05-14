\NeedsTeXFormat{LaTeX2e}[2022/06/01]
\ProvidesFile{xauatthesis-core.cls}
  [2026/05/06 v0.1 XAUAT thesis template core]

\RequirePackage{expl3}
\RequirePackage{xparse}
\RequirePackage{l3keys2e}

\ExplSyntaxOn

\tl_new:N \g_xauat_degree_tl
\tl_new:N \g_xauat_degree_type_tl
\tl_new:N \g_xauat_media_tl
\tl_new:N \g_xauat_review_tl
\tl_new:N \g_xauat_advisor_mode_tl
\tl_new:N \g_xauat_discipline_type_tl
\tl_new:N \g_xauat_bib_style_tl
\tl_new:N \g_xauat_blind_achievements_tl
\tl_new:N \g_xauat_blind_acknowledgement_tl

\def\xauat@system{auto}
\def\xauat@fontset{auto}
\def\xauat@font{auto}
\def\xauat@cjk@font{auto}
\def\xauat@windows@font@dir{C:/Windows/Fonts}
\def\xauat@math@font{auto}
\def\xauat@math@style{GB}

\keys_define:nn { xauat / option }
  {
    degree .choices:nn =
      { doctor, master }
      { \tl_gset:Nn \g_xauat_degree_tl {#1} },
    degree .initial:n = master,
    degree-type .choices:nn =
      { academic, professional }
      { \tl_gset:Nn \g_xauat_degree_type_tl {#1} },
    degree-type .initial:n = academic,
    media .choices:nn =
      { electronic, print }
      { \tl_gset:Nn \g_xauat_media_tl {#1} },
    media .initial:n = electronic,
    review .choices:nn =
      { normal, blind }
      { \tl_gset:Nn \g_xauat_review_tl {#1} },
    review .initial:n = normal,
    advisor-mode .choices:nn =
      { single, associate, team }
      { \tl_gset:Nn \g_xauat_advisor_mode_tl {#1} },
    advisor-mode .initial:n = single,
    discipline-type .choices:nn =
      { science, humanities }
      { \tl_gset:Nn \g_xauat_discipline_type_tl {#1} },
    discipline-type .initial:n = science,
    bib-style .choices:nn =
      { auto, numeric, authoryear }
      { \tl_gset:Nn \g_xauat_bib_style_tl {#1} },
    bib-style .initial:n = auto,
    blind-achievements .choices:nn =
      { hide, anonymous, show }
      { \tl_gset:Nn \g_xauat_blind_achievements_tl {#1} },
    blind-achievements .initial:n = hide,
    blind-acknowledgement .choices:nn =
      { hide, placeholder, show }
      { \tl_gset:Nn \g_xauat_blind_acknowledgement_tl {#1} },
    blind-acknowledgement .initial:n = hide,
    system .choices:nn =
      { auto, mac, unix, windows }
      { \def\xauat@system{#1} },
    system .initial:n = auto,
    fontset .choices:nn =
      { auto, windows, mac, noto, fandol, none }
      { \def\xauat@fontset{#1} },
    fontset .initial:n = auto,
    font .choices:nn =
      { auto, times, termes, none }
      { \def\xauat@font{#1} },
    font .initial:n = auto,
    cjk-font .choices:nn =
      { auto, windows, windows-local, mac, noto, fandol, none }
      { \def\xauat@cjk@font{#1} },
    cjk-font .initial:n = auto,
    windows-font-dir .code:n =
      { \def\xauat@windows@font@dir{#1} },
    math-font .choices:nn =
      { auto, xits, stix, libertinus, lm, none }
      { \def\xauat@math@font{#1} },
    math-font .initial:n = auto,
    math-style .choices:nn =
      { GB, ISO, TeX }
      { \def\xauat@math@style{#1} },
    math-style .initial:n = GB,
    unknown .code:n =
      {
        \ClassError { xauatthesis }
          { Unknown~class~option~'\l_keys_key_str' }
          { Check~the~option~name~or~remove~it. }
      }
  }
\ProcessKeysOptions { xauat / option }

\str_if_eq:VnTF \g_xauat_media_tl { print }
  { \PassOptionsToClass { twoside, openright } { ctexbook } }
  { \PassOptionsToClass { twoside, openany } { ctexbook } }

\ExplSyntaxOff

\PassOptionsToPackage{no-math}{fontspec}
\LoadClass[a4paper,UTF8,zihao=-4,scheme=plain,fontset=none]{ctexbook}

\ExplSyntaxOn

\tl_new:N \g_xauat_title_cn_tl
\tl_new:N \g_xauat_title_en_tl
\tl_new:N \g_xauat_author_cn_tl
\tl_new:N \g_xauat_author_en_tl
\tl_new:N \g_xauat_student_id_tl
\tl_new:N \g_xauat_school_cn_tl
\tl_new:N \g_xauat_school_en_tl
\tl_new:N \g_xauat_supervisor_cn_tl
\tl_new:N \g_xauat_supervisor_title_cn_tl
\tl_new:N \g_xauat_supervisor_en_tl
\tl_new:N \g_xauat_associate_supervisor_cn_tl
\tl_new:N \g_xauat_associate_supervisor_en_tl
\tl_new:N \g_xauat_advisor_team_cn_tl
\tl_new:N \g_xauat_advisor_team_en_tl
\tl_new:N \g_xauat_advisor_team_name_cn_tl
\tl_new:N \g_xauat_advisor_team_leader_name_tl
\tl_new:N \g_xauat_advisor_team_leader_discipline_tl
\tl_new:N \g_xauat_advisor_team_leader_title_tl
\tl_new:N \g_xauat_discipline_cn_tl
\tl_new:N \g_xauat_discipline_en_tl
\tl_new:N \g_xauat_professional_category_cn_tl
\tl_new:N \g_xauat_professional_category_en_tl
\tl_new:N \g_xauat_professional_field_cn_tl
\tl_new:N \g_xauat_professional_field_en_tl
\tl_new:N \g_xauat_degree_name_en_tl
\tl_new:N \g_xauat_defense_date_cn_tl
\tl_new:N \g_xauat_defense_date_en_tl
\tl_new:N \g_xauat_confidential_tl
\tl_new:N \g_xauat_thesis_type_cn_tl
\tl_new:N \g_xauat_thesis_type_en_tl
\tl_new:N \g_xauat_keywords_cn_tl
\tl_new:N \g_xauat_keywords_en_tl
\tl_new:N \g_xauat_funding_cn_tl
\tl_new:N \g_xauat_committee_chair_name_tl
\tl_new:N \g_xauat_committee_chair_title_tl
\tl_new:N \g_xauat_committee_chair_affiliation_tl
\tl_new:N \g_xauat_committee_member_i_name_tl
\tl_new:N \g_xauat_committee_member_i_title_tl
\tl_new:N \g_xauat_committee_member_i_affiliation_tl
\tl_new:N \g_xauat_committee_member_ii_name_tl
\tl_new:N \g_xauat_committee_member_ii_title_tl
\tl_new:N \g_xauat_committee_member_ii_affiliation_tl
\tl_new:N \g_xauat_committee_member_iii_name_tl
\tl_new:N \g_xauat_committee_member_iii_title_tl
\tl_new:N \g_xauat_committee_member_iii_affiliation_tl
\tl_new:N \g_xauat_committee_member_iv_name_tl
\tl_new:N \g_xauat_committee_member_iv_title_tl
\tl_new:N \g_xauat_committee_member_iv_affiliation_tl
\tl_new:N \g_xauat_committee_member_v_name_tl
\tl_new:N \g_xauat_committee_member_v_title_tl
\tl_new:N \g_xauat_committee_member_v_affiliation_tl
\tl_new:N \g_xauat_committee_member_vi_name_tl
\tl_new:N \g_xauat_committee_member_vi_title_tl
\tl_new:N \g_xauat_committee_member_vi_affiliation_tl
\seq_new:N \g_xauat_advisor_team_members_seq
\seq_new:N \g_xauat_advisor_team_member_names_seq
\seq_new:N \g_xauat_advisor_team_member_disciplines_seq
\seq_new:N \g_xauat_advisor_team_member_titles_seq
\seq_new:N \g_xauat_committee_members_seq
\seq_new:N \g_xauat_committee_member_names_seq
\seq_new:N \g_xauat_committee_member_titles_seq
\seq_new:N \g_xauat_committee_member_affiliations_seq
\tl_gset:Nn \g_xauat_confidential_tl { false }

\keys_define:nn { xauat / metadata }
  {
    title-cn .tl_gset:N = \g_xauat_title_cn_tl,
    title-en .tl_gset:N = \g_xauat_title_en_tl,
    author-cn .tl_gset:N = \g_xauat_author_cn_tl,
    author-en .tl_gset:N = \g_xauat_author_en_tl,
    student-id .tl_gset:N = \g_xauat_student_id_tl,
    school-cn .tl_gset:N = \g_xauat_school_cn_tl,
    school-en .tl_gset:N = \g_xauat_school_en_tl,
    supervisor-cn .tl_gset:N = \g_xauat_supervisor_cn_tl,
    supervisor-title-cn .tl_gset:N = \g_xauat_supervisor_title_cn_tl,
    supervisor-en .tl_gset:N = \g_xauat_supervisor_en_tl,
    associate-supervisor-cn .tl_gset:N = \g_xauat_associate_supervisor_cn_tl,
    associate-supervisor-en .tl_gset:N = \g_xauat_associate_supervisor_en_tl,
    advisor-team-cn .tl_gset:N = \g_xauat_advisor_team_cn_tl,
    advisor-team-en .tl_gset:N = \g_xauat_advisor_team_en_tl,
    advisor-team-name-cn .tl_gset:N = \g_xauat_advisor_team_name_cn_tl,
    discipline-cn .tl_gset:N = \g_xauat_discipline_cn_tl,
    discipline-en .tl_gset:N = \g_xauat_discipline_en_tl,
    professional-category-cn .tl_gset:N = \g_xauat_professional_category_cn_tl,
    professional-category-en .tl_gset:N = \g_xauat_professional_category_en_tl,
    professional-field-cn .tl_gset:N = \g_xauat_professional_field_cn_tl,
    professional-field-en .tl_gset:N = \g_xauat_professional_field_en_tl,
    degree-name-en .tl_gset:N = \g_xauat_degree_name_en_tl,
    defense-date-cn .tl_gset:N = \g_xauat_defense_date_cn_tl,
    defense-date-en .tl_gset:N = \g_xauat_defense_date_en_tl,
    confidential .choices:nn =
      { true, false }
      { \tl_gset:Nn \g_xauat_confidential_tl {#1} },
    confidential .initial:n = false,
    thesis-type-cn .tl_gset:N = \g_xauat_thesis_type_cn_tl,
    thesis-type-en .tl_gset:N = \g_xauat_thesis_type_en_tl,
    keywords-cn .tl_gset:N = \g_xauat_keywords_cn_tl,
    keywords-en .tl_gset:N = \g_xauat_keywords_en_tl,
    funding-cn .tl_gset:N = \g_xauat_funding_cn_tl,
    committee-chair-name .tl_gset:N = \g_xauat_committee_chair_name_tl,
    committee-chair-title .tl_gset:N = \g_xauat_committee_chair_title_tl,
    committee-chair-affiliation .tl_gset:N = \g_xauat_committee_chair_affiliation_tl,
    committee-member-i-name .tl_gset:N = \g_xauat_committee_member_i_name_tl,
    committee-member-i-title .tl_gset:N = \g_xauat_committee_member_i_title_tl,
    committee-member-i-affiliation .tl_gset:N = \g_xauat_committee_member_i_affiliation_tl,
    committee-member-ii-name .tl_gset:N = \g_xauat_committee_member_ii_name_tl,
    committee-member-ii-title .tl_gset:N = \g_xauat_committee_member_ii_title_tl,
    committee-member-ii-affiliation .tl_gset:N = \g_xauat_committee_member_ii_affiliation_tl,
    committee-member-iii-name .tl_gset:N = \g_xauat_committee_member_iii_name_tl,
    committee-member-iii-title .tl_gset:N = \g_xauat_committee_member_iii_title_tl,
    committee-member-iii-affiliation .tl_gset:N = \g_xauat_committee_member_iii_affiliation_tl,
    committee-member-iv-name .tl_gset:N = \g_xauat_committee_member_iv_name_tl,
    committee-member-iv-title .tl_gset:N = \g_xauat_committee_member_iv_title_tl,
    committee-member-iv-affiliation .tl_gset:N = \g_xauat_committee_member_iv_affiliation_tl,
    committee-member-v-name .tl_gset:N = \g_xauat_committee_member_v_name_tl,
    committee-member-v-title .tl_gset:N = \g_xauat_committee_member_v_title_tl,
    committee-member-v-affiliation .tl_gset:N = \g_xauat_committee_member_v_affiliation_tl,
    committee-member-vi-name .tl_gset:N = \g_xauat_committee_member_vi_name_tl,
    committee-member-vi-title .tl_gset:N = \g_xauat_committee_member_vi_title_tl,
    committee-member-vi-affiliation .tl_gset:N = \g_xauat_committee_member_vi_affiliation_tl,
    unknown .code:n =
      {
        \ClassError { xauatthesis }
          { Unknown~metadata~key~'\l_keys_key_str' }
          { Check~metadata.tex~for~a~misspelled~key. }
      }
  }

\NewDocumentCommand \XAUATsetup { m }
  { \keys_set:nn { xauat / metadata } {#1} }

\NewDocumentCommand \XAUATcommitteeChair { m m m }
  {
    \tl_gset:Nn \g_xauat_committee_chair_name_tl {#1}
    \tl_gset:Nn \g_xauat_committee_chair_title_tl {#2}
    \tl_gset:Nn \g_xauat_committee_chair_affiliation_tl {#3}
  }
\NewDocumentCommand \XAUATcommitteeMember { m m m }
  {
    \seq_gput_right:Nn \g_xauat_committee_members_seq { {#1} {#2} {#3} }
    \seq_gput_right:Nn \g_xauat_committee_member_names_seq {#1}
    \seq_gput_right:Nn \g_xauat_committee_member_titles_seq {#2}
    \seq_gput_right:Nn \g_xauat_committee_member_affiliations_seq {#3}
  }
\NewDocumentCommand \XAUATclearCommitteeMembers { }
  {
    \seq_gclear:N \g_xauat_committee_members_seq
    \seq_gclear:N \g_xauat_committee_member_names_seq
    \seq_gclear:N \g_xauat_committee_member_titles_seq
    \seq_gclear:N \g_xauat_committee_member_affiliations_seq
  }

\NewDocumentCommand \XAUATadvisorTeamLeader { m m m }
  {
    \tl_gset:Nn \g_xauat_advisor_team_leader_name_tl {#1}
    \tl_gset:Nn \g_xauat_advisor_team_leader_discipline_tl {#2}
    \tl_gset:Nn \g_xauat_advisor_team_leader_title_tl {#3}
  }
\NewDocumentCommand \XAUATadvisorTeamMember { m m m }
  {
    \seq_gput_right:Nn \g_xauat_advisor_team_members_seq { {#1} {#2} {#3} }
    \seq_gput_right:Nn \g_xauat_advisor_team_member_names_seq {#1}
    \seq_gput_right:Nn \g_xauat_advisor_team_member_disciplines_seq {#2}
    \seq_gput_right:Nn \g_xauat_advisor_team_member_titles_seq {#3}
  }
\NewDocumentCommand \XAUATclearAdvisorTeamMembers { }
  {
    \seq_gclear:N \g_xauat_advisor_team_members_seq
    \seq_gclear:N \g_xauat_advisor_team_member_names_seq
    \seq_gclear:N \g_xauat_advisor_team_member_disciplines_seq
    \seq_gclear:N \g_xauat_advisor_team_member_titles_seq
  }

\NewDocumentCommand \xauatifdoctor { m m }
  { \str_if_eq:VnTF \g_xauat_degree_tl { doctor } {#1} {#2} }
\NewDocumentCommand \xauatifmaster { m m }
  { \str_if_eq:VnTF \g_xauat_degree_tl { master } {#1} {#2} }
\NewDocumentCommand \xauatifacademic { m m }
  { \str_if_eq:VnTF \g_xauat_degree_type_tl { academic } {#1} {#2} }
\NewDocumentCommand \xauatifprofessional { m m }
  { \str_if_eq:VnTF \g_xauat_degree_type_tl { professional } {#1} {#2} }
\NewDocumentCommand \xauatifprint { m m }
  { \str_if_eq:VnTF \g_xauat_media_tl { print } {#1} {#2} }
\NewDocumentCommand \xauatifblind { m m }
  { \str_if_eq:VnTF \g_xauat_review_tl { blind } {#1} {#2} }
\NewDocumentCommand \xauatifconfidential { m m }
  { \str_if_eq:VnTF \g_xauat_confidential_tl { true } {#1} {#2} }
\NewDocumentCommand \xauatifhumanities { m m }
  { \str_if_eq:VnTF \g_xauat_discipline_type_tl { humanities } {#1} {#2} }
\NewDocumentCommand \xauatifbibauthoryear { m m }
  {
    \str_if_eq:VnTF \g_xauat_bib_style_tl { authoryear }
      {#1}
      {
        \str_if_eq:VnTF \g_xauat_bib_style_tl { auto }
          { \xauatifhumanities {#1} {#2} }
          {#2}
      }
  }
\NewDocumentCommand \xauatifadvisorteam { m m }
  { \str_if_eq:VnTF \g_xauat_advisor_mode_tl { team } {#1} {#2} }
\NewDocumentCommand \xauatifassociateadvisor { m m }
  { \str_if_eq:VnTF \g_xauat_advisor_mode_tl { associate } {#1} {#2} }
\NewDocumentCommand \xauatifblindachievementhide { m m }
  { \str_if_eq:VnTF \g_xauat_blind_achievements_tl { hide } {#1} {#2} }
\NewDocumentCommand \xauatifblindachievementanonymous { m m }
  { \str_if_eq:VnTF \g_xauat_blind_achievements_tl { anonymous } {#1} {#2} }
\NewDocumentCommand \xauatifblindacknowledgementhide { m m }
  { \str_if_eq:VnTF \g_xauat_blind_acknowledgement_tl { hide } {#1} {#2} }
\NewDocumentCommand \xauatifblindacknowledgementplaceholder { m m }
  { \str_if_eq:VnTF \g_xauat_blind_acknowledgement_tl { placeholder } {#1} {#2} }

\NewDocumentCommand \xauatDegreeNameCN {} { \xauatifdoctor { 博士 } { 硕士 } }
\NewDocumentCommand \xauatDegreeNameEN {} { \xauatifdoctor { Doctoral } { Master's } }
\NewDocumentCommand \xauatDegreeTypeCN {} { \xauatifacademic { 学术学位 } { 专业学位 } }
\NewDocumentCommand \xauatDegreeTypeEN {} { \xauatifacademic { Academic~Degree } { Professional~Degree } }
\NewDocumentCommand \xauatDegreePaperCN {} { \xauatDegreeNameCN 学位论文 }
\NewDocumentCommand \xauatDegreePaperEN {} { \xauatDegreeNameEN~Thesis }
\NewDocumentCommand \xauatMajorLabelCN {} { \xauatifacademic { 学科名称 } { 类别（领域） } }
\NewDocumentCommand \xauatMajorLabelEN {} { \xauatifacademic { Discipline } { Category~and~Field } }
\NewDocumentCommand \xauatDegreeFullEN {}
  {
    \tl_if_empty:NTF \g_xauat_degree_name_en_tl
      {
        \xauatifdoctor
          {
            \xauatifacademic
              { Doctor~of~Philosophy }
              { Doctor~of~\tl_use:N \g_xauat_professional_category_en_tl }
          }
          { Master~of~\tl_use:N \g_xauat_professional_category_en_tl }
      }
      { \tl_use:N \g_xauat_degree_name_en_tl }
  }

\NewDocumentCommand \xauatTitleCN {} { \tl_use:N \g_xauat_title_cn_tl }
\NewDocumentCommand \xauatTitleEN {} { \tl_use:N \g_xauat_title_en_tl }
\NewDocumentCommand \xauatAuthorCN {} { \tl_use:N \g_xauat_author_cn_tl }
\NewDocumentCommand \xauatAuthorEN {} { \tl_use:N \g_xauat_author_en_tl }
\NewDocumentCommand \xauatStudentID {} { \tl_use:N \g_xauat_student_id_tl }
\NewDocumentCommand \xauatSchoolCN {} { \tl_use:N \g_xauat_school_cn_tl }
\NewDocumentCommand \xauatSchoolEN {} { \tl_use:N \g_xauat_school_en_tl }
\NewDocumentCommand \xauatSupervisorCN {} { \tl_use:N \g_xauat_supervisor_cn_tl }
\NewDocumentCommand \xauatSupervisorTitleCN {} { \tl_use:N \g_xauat_supervisor_title_cn_tl }
\NewDocumentCommand \xauatSupervisorEN {} { \tl_use:N \g_xauat_supervisor_en_tl }
\NewDocumentCommand \xauatAssociateSupervisorCN {} { \tl_use:N \g_xauat_associate_supervisor_cn_tl }
\NewDocumentCommand \xauatAssociateSupervisorEN {} { \tl_use:N \g_xauat_associate_supervisor_en_tl }
\NewDocumentCommand \xauatAdvisorTeamCN {} { \tl_use:N \g_xauat_advisor_team_cn_tl }
\NewDocumentCommand \xauatAdvisorTeamEN {} { \tl_use:N \g_xauat_advisor_team_en_tl }
\NewDocumentCommand \xauatAdvisorTeamNameCN {} { \tl_use:N \g_xauat_advisor_team_name_cn_tl }
\NewDocumentCommand \xauatAdvisorTeamLeaderName {} { \tl_use:N \g_xauat_advisor_team_leader_name_tl }
\NewDocumentCommand \xauatAdvisorTeamLeaderDiscipline {} { \tl_use:N \g_xauat_advisor_team_leader_discipline_tl }
\NewDocumentCommand \xauatAdvisorTeamLeaderTitle {} { \tl_use:N \g_xauat_advisor_team_leader_title_tl }
\NewDocumentCommand \xauatProfessionalCategoryEN {} { \tl_use:N \g_xauat_professional_category_en_tl }
\NewDocumentCommand \xauatDefenseDateCN {} { \tl_use:N \g_xauat_defense_date_cn_tl }
\NewDocumentCommand \xauatDefenseDateEN {} { \tl_use:N \g_xauat_defense_date_en_tl }
\NewDocumentCommand \xauatThesisTypeCN {} { \tl_use:N \g_xauat_thesis_type_cn_tl }
\NewDocumentCommand \xauatThesisTypeEN {} { \tl_use:N \g_xauat_thesis_type_en_tl }
\NewDocumentCommand \xauatKeywordsCN {} { \tl_use:N \g_xauat_keywords_cn_tl }
\NewDocumentCommand \xauatKeywordsEN {} { \tl_use:N \g_xauat_keywords_en_tl }
\NewDocumentCommand \xauatFundingCN {} { \tl_use:N \g_xauat_funding_cn_tl }
\NewDocumentCommand \xauatCommitteeChairName {} { \tl_use:N \g_xauat_committee_chair_name_tl }
\NewDocumentCommand \xauatCommitteeChairTitle {} { \tl_use:N \g_xauat_committee_chair_title_tl }
\NewDocumentCommand \xauatCommitteeChairAffiliation {} { \tl_use:N \g_xauat_committee_chair_affiliation_tl }
\NewDocumentCommand \xauatCommitteeMemberIName {} { \tl_use:N \g_xauat_committee_member_i_name_tl }
\NewDocumentCommand \xauatCommitteeMemberITitle {} { \tl_use:N \g_xauat_committee_member_i_title_tl }
\NewDocumentCommand \xauatCommitteeMemberIAffiliation {} { \tl_use:N \g_xauat_committee_member_i_affiliation_tl }
\NewDocumentCommand \xauatCommitteeMemberIIName {} { \tl_use:N \g_xauat_committee_member_ii_name_tl }
\NewDocumentCommand \xauatCommitteeMemberIITitle {} { \tl_use:N \g_xauat_committee_member_ii_title_tl }
\NewDocumentCommand \xauatCommitteeMemberIIAffiliation {} { \tl_use:N \g_xauat_committee_member_ii_affiliation_tl }
\NewDocumentCommand \xauatCommitteeMemberIIIName {} { \tl_use:N \g_xauat_committee_member_iii_name_tl }
\NewDocumentCommand \xauatCommitteeMemberIIITitle {} { \tl_use:N \g_xauat_committee_member_iii_title_tl }
\NewDocumentCommand \xauatCommitteeMemberIIIAffiliation {} { \tl_use:N \g_xauat_committee_member_iii_affiliation_tl }
\NewDocumentCommand \xauatCommitteeMemberIVName {} { \tl_use:N \g_xauat_committee_member_iv_name_tl }
\NewDocumentCommand \xauatCommitteeMemberIVTitle {} { \tl_use:N \g_xauat_committee_member_iv_title_tl }
\NewDocumentCommand \xauatCommitteeMemberIVAffiliation {} { \tl_use:N \g_xauat_committee_member_iv_affiliation_tl }
\NewDocumentCommand \xauatCommitteeMemberVName {} { \tl_use:N \g_xauat_committee_member_v_name_tl }
\NewDocumentCommand \xauatCommitteeMemberVTitle {} { \tl_use:N \g_xauat_committee_member_v_title_tl }
\NewDocumentCommand \xauatCommitteeMemberVAffiliation {} { \tl_use:N \g_xauat_committee_member_v_affiliation_tl }
\NewDocumentCommand \xauatCommitteeMemberVIName {} { \tl_use:N \g_xauat_committee_member_vi_name_tl }
\NewDocumentCommand \xauatCommitteeMemberVITitle {} { \tl_use:N \g_xauat_committee_member_vi_title_tl }
\NewDocumentCommand \xauatCommitteeMemberVIAffiliation {} { \tl_use:N \g_xauat_committee_member_vi_affiliation_tl }

\cs_new:Npn \xauat_seq_item_or_empty:Nn #1#2
  {
    \int_compare:nTF { #2 <= \seq_count:N #1 }
      { \seq_item:Nn #1 {#2} }
      {}
  }
\NewDocumentCommand \xauatAdvisorTeamMemberNameAt { m }
  { \xauat_seq_item_or_empty:Nn \g_xauat_advisor_team_member_names_seq {#1} }
\NewDocumentCommand \xauatAdvisorTeamMemberDisciplineAt { m }
  { \xauat_seq_item_or_empty:Nn \g_xauat_advisor_team_member_disciplines_seq {#1} }
\NewDocumentCommand \xauatAdvisorTeamMemberTitleAt { m }
  { \xauat_seq_item_or_empty:Nn \g_xauat_advisor_team_member_titles_seq {#1} }
\NewDocumentCommand \xauatCommitteeMemberNameAt { m }
  { \xauat_seq_item_or_empty:Nn \g_xauat_committee_member_names_seq {#1} }
\NewDocumentCommand \xauatCommitteeMemberTitleAt { m }
  { \xauat_seq_item_or_empty:Nn \g_xauat_committee_member_titles_seq {#1} }
\NewDocumentCommand \xauatCommitteeMemberAffiliationAt { m }
  { \xauat_seq_item_or_empty:Nn \g_xauat_committee_member_affiliations_seq {#1} }

\NewDocumentCommand \xauatMajorValueCN {}
  {
    \xauatifacademic
      { \tl_use:N \g_xauat_discipline_cn_tl }
      {
        \tl_use:N \g_xauat_professional_category_cn_tl
        \tl_if_empty:NF \g_xauat_professional_field_cn_tl
          { （ \tl_use:N \g_xauat_professional_field_cn_tl ） }
      }
  }
\NewDocumentCommand \xauatMajorValueEN {}
  {
    \xauatifacademic
      { \tl_use:N \g_xauat_discipline_en_tl }
      {
        \tl_use:N \g_xauat_professional_category_en_tl
        \tl_if_empty:NF \g_xauat_professional_field_en_tl
          { ~ ( \tl_use:N \g_xauat_professional_field_en_tl ) }
      }
  }

\ExplSyntaxOff

\InputIfFileExists{xauatthesis.cfg}
  {}
  {
    \ClassError{xauatthesis}
      {Cannot find xauatthesis.cfg}
      {Make sure the template source directory is in input@path.}
  }

\InputIfFileExists{xauatthesis-packages.sty}
  {}
  { \ClassError{xauatthesis}{Cannot find xauatthesis-packages.sty}{} }
\InputIfFileExists{xauatthesis-debug.sty}
  {}
  { \ClassError{xauatthesis}{Cannot find xauatthesis-debug.sty}{} }
\InputIfFileExists{xauatthesis-layout.sty}
  {}
  { \ClassError{xauatthesis}{Cannot find xauatthesis-layout.sty}{} }
\InputIfFileExists{xauatthesis-blind.sty}
  {}
  { \ClassError{xauatthesis}{Cannot find xauatthesis-blind.sty}{} }
\InputIfFileExists{xauatthesis-writing.sty}
  {}
  { \ClassError{xauatthesis}{Cannot find xauatthesis-writing.sty}{} }
\InputIfFileExists{xauatthesis-frontmatter.sty}
  {}
  { \ClassError{xauatthesis}{Cannot find xauatthesis-frontmatter.sty}{} }
\InputIfFileExists{xauatthesis-bib.sty}
  {}
  { \ClassError{xauatthesis}{Cannot find xauatthesis-bib.sty}{} }
\InputIfFileExists{xauatthesis-backmatter.sty}
  {}
  { \ClassError{xauatthesis}{Cannot find xauatthesis-backmatter.sty}{} }

\endinput
