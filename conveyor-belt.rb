require 'csv'

# CONFIG OPTIONS

FILE_PATH = 'submissions.csv'
PROJECT_DESCRIPTION_KEY = 'Tagline'
PROJECT_LOCATION_KEY = 'Team ID/Table No.'
HAMMER = true

# END CONFIG OPTIONS

submissions = CSV.parse(File.read(FILE_PATH), headers: true)

waves = 2

projects = []

judges = []

wave_assignments = {}

counter = 1

submissions.each do |submission|
  unless wave_assignments.has_key?(submission['Team'])
    wave_assignments[submission['Team']] = counter
    counter = if counter != waves
                counter + 1
              else
                1
              end
    if HAMMER
      projects.push({
                      name: submission['Project Title'],
                      wave: wave_assignments[submission['Team']],
                      description: submission[PROJECT_DESCRIPTION_KEY],
                      location: submission[PROJECT_LOCATION_KEY]
                    })
    else
      projects.push({
                      name: submission['Project Title'],
                      description: submission[PROJECT_DESCRIPTION_KEY],
                      location: submission[PROJECT_LOCATION_KEY]
                    })
    end
  end
  judges.push({
                name: submission['Name'],
                wave: wave_assignments[submission['Team']],
                email: submission['Email'],
                description: "Member of #{submission['Team']}."
              })
end

if HAMMER
  CSV.open('judges.csv', 'w') do |csv|
    judges.each do |judge|
      csv << judge.values
    end
  end
end

CSV.open('projects.csv', 'w') do |csv|
  projects.each do |project|
    csv << project.values
  end
end
