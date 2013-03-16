import fileinput

# FSM states
DATE  = 1
FILES = 2

state = DATE
date = None

def add_activity(activities, date, file_name, activity):
  if   not activities.has_key(date):            activities[date] = {file_name: activity}
  elif not activities[date].has_key(file_name): activities[date][file_name] =  activity
  else:                                         activities[date][file_name] += activity

def pnum(s): return int(s) if s != '-' else 0

activities = {}

for line in fileinput.input():
  line = line.strip()
  if state == DATE:
    date = line
    state = FILES
  elif state == FILES:
    if len(line) == 0: state = DATE
    else:
      (adds, dels, file_name) = line.split('\t')
      add_activity(activities, date, file_name, pnum(adds) + pnum(dels))

print('date,file,activity')
for date in sorted(activities.keys()):
  for file_name in sorted(activities[date].keys()):
    activity = activities[date][file_name]
    print('%s,%s,%s' % (date, file_name, activity))

