# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)



master_admin = [
  ["super.admin@kcl.ac.uk", "superpassword", "all schemes", [], [], ["admins", "coordinators", "matches", "admin_mailings", "mailing_list"]],
  ["admin.1@kcl.ac.uk", "adminpassword", "no schemes", [], [], []],
  ["adnin.2@kcl.ac.uk", "adminpassword", "no schemes", [], [], []],
  ["tom.hampton@kcl.ac.uk", "tpass", "no schemes", [], [], []],
  ["richard@kcl.ac.uk", "rpass", "no schemes", [], [], []],
  ["john.doe@kcl.ac.uk", "jpass", "no schemes", [], [], []],
  ["billy.roe@kcl.ac.uk", "bpass", "no schemes", [], [], []]
]

master_admin.each do |temp|
  admin = Admin.create(
    username: temp[0],
    scheme_access: temp[2],
    department_ids: temp[3],
    scheme_ids: temp[4],
    admin_access: temp[5]
  )
  admin.password = temp[1]
  admin.save
end

master_user = [
  ["coordinator.1@hotmail.com", "mypassword", "rob", "rick"],
  ["coordinator.2@hotmail.com", "mypassword", "ruby", "riss"],
  ["menteeA@hotmail.com", "mypassword", "john", "jack"],
  ["menteeB@hotmail.com", "mypassword", "lily", "lake"],
  ["mentorA@hotmail.com", "mypassword", "jackie", "jones"],
  ["mentorB@hotmail.com", "mypassword", "lola", "cool"],
  ["lilo.hope@hotmail.co.uk", "mypassword", "lilo", "hope"]
]

master_user.each do |temp|
  User.create(
    username: temp[0],
    password: temp[1],
    gender: temp[2],
    first_name: temp[3],
    last_name: temp[4],
    age: temp[5]
  )
end

master_mailing = [
 "schemebuddy@gmail.com"
]

master_mailing.each do |temp|
 MailingList.create(email: temp)
end

master_department = [
  "maths",
  "computer science"
]

master_department.each do |temp|
  Department.create(name: temp)
end

master_scheme = [
  [1, 1, "Math scheme 1", "Scheme 1 description", "This is a code of conduct for scheme 1. Sample text.", Date.new(2022,1,1), Date.new(2022,6,1)],
  [2, 1, "Math scheme 2", "Scheme 2 description", "This is a code of conduct for scheme 2. Sample text.", Date.new(2022,6,2), Date.new(2022,12,28)],
  [3, 2, "Computer science scheme 1", "Scheme 1 description", "This is a code of conduct for scheme 1. Sample text.", Date.new(2022,6,1), Date.new(2023,12,28)],
  [4, 2, "Computer science scheme 2", "Scheme 2 description", "This is a code of conduct for scheme 2. Sample text.", Date.new(2023,1,1), Date.new(2023,6,28)]
]

master_scheme.each do |temp|
  Scheme.create(
    id: temp[0],
    department_id: temp[1],
    title: temp[2],
    description: temp[3],
    codeOfConduct: temp[4],
    startDate: temp[5],
    endDate: temp[6]
  )

  EnrollLink.create(
    scheme_id: temp[0],
    mentee_link: "http://127.0.0.1:3000/mentee/" + temp[0].to_s + "/"+SecureRandom.hex(25),
    mentor_link: "http://127.0.0.1:3000/mentor/" + temp[0].to_s + "/"+SecureRandom.hex(25)
   )
end

master_questionnaire = [
  [1, "Questionnaire 1", "This is math questionnaire 1"],
  [2, "Questionnaire 2", "This is math questionnaire 2"],
  [3, "Questionnaire 1", "This is computer science questionnaire 1"],
  [4, "Questionnaire 2", "This is computer science questionnaire 2"]
]

master_questionnaire.each do |temp|
  Questionnaire.create(
    scheme_id: temp[0],
    name: temp[1],
    description: temp[2]
  )
end

question_master = [
  [1, "Gender", ["Male", "Female", "Other", "No preference"], false, false, false],
  [1, "Race", ["Asian", "American", "White", "Black", "Other"], false, false, false],
  [1, "Age", ["20-", "20-25", "25+"], false, false, false],
  [1, "Timezone", ["GMT", "PST", "Other"], false, false, false],
  [2, "Gender", ["Male", "Female", "Other", "No preference"], false, false, false],
  [2, "Race", ["Asian", "American", "White", "Black", "Other"], false, false, false],
  [2, "Age", ["20-", "20-25", "25+"], false, false, false],
  [2, "Timezone", ["GMT", "PST", "Other"], false, false, false],
  [3, "Preferred gender", ["Male", "Female", "Other", "No preference"], false, false, false],
  [3, "Race", ["Asian", "American", "White", "Black", "Other"], false, false, false],
  [3, "Timezone", ["GMT", "PST", "Other"], false, false, false],
  [4, "Preferred gender", ["Male", "Female", "Other", "No preference"], false, false, false],
  [4, "Race", ["Asian", "American", "White", "Black", "Other"], false, false, false],
  [4, "Timezone", ["GMT", "PST", "Other"], false, false, false]
]

question_master.each do |temp|
 Question.create(
   questionnaire_id: temp[0],
   description: temp[1],
   options: temp[2],
   match: temp[3],
   matching_up_to_user: temp[4],
   give_priority: temp[5]
 )
end

answers_master = [
 [1, 1, ["Male","Asian", "20-", "GMT"]],
 [1, 2, ["Female","American", "20-25", "GMT"]],
 [1, 3, ["Male","Asian", "25+", "PST"]],
 [1, 4, ["Other","White", "20-", "Other"]],
 [3, 5, ["Male","Other", "Other"]],
 [3, 6, ["Female","Black", "PST"]],
]

answers_master.each do |temp|
 answer = Answer.create(
   questionnaire_id: temp[0],
   user_id: temp[1],
   user_answers: temp[2]
 )
end

enroll_in_master = [
 ["coordinator",1, 1, false],
 ["mentee", 2, 1,false],
 ["mentee", 3, 1,false],
 ["mentor", 4, 1,false],
 ["mentor", 5, 1,false],
 ["mentor", 6, 1,false],
 ["mentee", 2, 2,false],
 ["mentee", 3, 2,false],
 ["mentor", 4, 2,false],
 ["mentor", 5, 1,false],
 ["mentor", 6, 1,false]
]


enroll_in_master.each do |temp|
  EnrollIn.create(
   role: temp[0],
   user_id: temp[1],
   scheme_id: temp[2],
   matched: temp[3],
   mentees_number: 5
 )
end

# To test match things
# match_master = [
#  [1, 3, 1],
#  [1, 3, 2],
#  [2, 4, 1],
#  [4, 2, 2]
# ]
# To test match things
# match_master.each do |temp|
#  match = Match.create(
#    mentor_id: temp[0],
#    mentee_id: temp[1],
#    scheme_id: temp[2]
#  )
#end
