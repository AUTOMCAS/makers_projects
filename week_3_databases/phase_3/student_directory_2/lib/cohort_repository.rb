require 'cohort'
require 'student'

class CohortRepository
  def all
    sql = 'SELECT id, name, starting_date FROM cohorts;'
    result_set  = DatabaseConnection.exec_params(sql, [])
  
    cohorts = []
  
    result_set.each do |record|
      cohort = Cohort.new
      cohort.id = record['id']
      cohort.name = record['name']
      cohort.starting_date = record['starting_date']
  
      cohorts << cohort
    end
  
    return cohorts
  end

  def finds_with_students(id)
    sql = 'SELECT cohorts.id,
                  cohorts.name,
                  cohorts.starting_date,
                  students.id AS student_id,
                  students.name
          FROM cohorts
          JOIN students ON students.cohort_id = cohorts.id
          WHERE cohorts.id = $1;'

    params = [id]

    result = DatabaseConnection.exec_params(sql, params)

    cohort = Cohort.new
    cohort.id = result.first['id']
    cohort.name = result.first['name']
    cohort.starting_date = result.first['starting_date']

    result.each do |record|
      student = Student.new
      student.id = record['cohort_id']
      student.name = record['name']
  
    cohort.students << student
    end
    return cohort
  end
end

