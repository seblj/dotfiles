import os

class Report:

    def __init__(self):
        self.exam = False
        self.assignment = "Assignment 1"
        self.name = "Sebastian Lyng Johansen"
        self.key = "INF-2700"
        self.subject_name = "Database Systems"
        self.subject = {
            "INF-1100" : "Introduction to Programming and Computer Behavior",
            "INF-1101" : "Data Structures and Algorithms",
            "INF-1400" : "Object-Oriented Programming",
            "INF-2200" : "Computer Organization and Design",
            "INF-2201" : "Operating System Fundamentals",
            "INF-2300" : "Computer Communication",
            "INF-2202" : "Concurrent and Data-Intensive Programming",
            "INF-2700" : "Database Systems",
            "INF-2900" : "Software Engineering",
            "INF-2310" : "Computer Security",
            "INF-2220" : "Cloud and Big Data Technology",
            "INF-3200" : "Distributed Systems Fundamentals",
            "INF-3201" : "Parallel Programming",
            "INF-3203" : "Advanced Distributed Systems",
            "INF-3701" : "Advanced Database Systems",
            "INF-3990" : "Master's Thesis in Computer Science"
        }

    def find_assignmentnumber(self):

        path = os.getcwd() 

        if "exam" in path:
            self.exam = True

        for i in range(1, 20):
            a = "a" + str(i)
            assignment = "assignment-" + str(i)
            project = "project-" + str(i)
            if a in path:
                self.assignment = "Assignment " + str(i)
                return

            elif assignment in path:
                self.assignment = "Assignment " + str(i)
                return

            elif project in path:
                self.assignment = "Project " + str(i)
                return


    def move_templates(self):
        os.system("cp ~/UiT/resources/latex_template/report.tex $PWD")
        os.system("cp ~/UiT/resources/latex_template/report.pdf $PWD")
        os.system("cp ~/UiT/resources/latex_template/references.bib $PWD")


    def edit_template(self):

        file = open("report.tex")
        lines = file.readlines()
        file.close()

        titlesearch = r"\newcommand{\subjecttitle}{subject}"
        keysearch = r"\newcommand{\subjectkey}{key}"
        assignmentsearch = r"\newcommand{\assignmentnum}{num}"

        newtitle = r"\newcommand{\subjecttitle}" + "{" + f"{self.subject[self.subject_key]}" + "}\n"
        newkey = r"\newcommand{\subjectkey}" + "{" + f"{self.subject_key}" + "}\n"
        newassignment = r"\newcommand{\assignmentnum}" + "{" + f"{self.assignment}" + "}\n"

        for idx, line in enumerate(lines):

            if titlesearch in line:
                lines[idx] = newtitle
            
            if keysearch in line:
                lines[idx] = newkey
            
            if assignmentsearch in line:
                lines[idx] = newassignment

            if self.exam:
                if self.name in line:
                    if r"\rhead" in line:
                        lines[idx] = r"\rhead{}"
                    else:
                        lines[idx] = ""

        with open("report.tex", "w") as fout:
            for line in lines:
                fout.write(line)


    def subject_key(self):

        path = os.getcwd() 
        for key in self.subject:
            if key.lower() in path.lower():
                self.subject_key = key
                return 


if __name__ == '__main__':
    report = Report()
    report.find_assignmentnumber()
    report.subject_key()
    report.move_templates()
    report.edit_template()



