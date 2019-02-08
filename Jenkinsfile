/*
@Autor: Denys Buedo Hidalgo
@Proyecto: BC-Bareta IC
@Joint China-Cuba Laboratory
@Universidad de las Ciencias Informáticas
*/

node {
    
    //--- load new task data ---
	echo "Reading task's data"
    def task = readFile "$JENKINS_HOME/workspace/BC-Vareta/task-config.xml"
	def parser = new XmlParser().parseText(task)
	def job = "${parser.attribute("Job")}"
	def owner_job = "${parser.attribute("Owner")}"
	def eeg = "${parser.attribute("EEG")}"
	def leadfield ="${parser.attribute("LeadField")}"
    def surface ="${parser.attribute("Surface")}"
	def scalp="${parser.attribute("Scalp")}"
	 
	//--- Setting Build description ---
	def current_task = "$BC-Vareta#: job-$owner_job" 
	currentBuild.displayName = "$current_task"
    
    //--- Load data stage ---
    stage('Data Acquisition'){

       //--- Opening ssh connection with the Freesurfer server ---
       sshagent(['id_rsa_fsf']) {    
           
			//--- Creating data files ---
			def data_file =  new File ("$JENKINS_HOME/workspace/BC-Vareta/data.txt")
			def eeg_file = new File ("$JENKINS_HOME/workspace/BC-Vareta/$eeg")
			def leadfield_file = new File ("$JENKINS_HOME/workspace/BC-Vareta/$leadfield")
			def surface_file = new File ("$JENKINS_HOME/workspace/BC-Vareta/$surface")
			def scalp_file = new File ("$JENKINS_HOME/workspace/BC-Vareta/$scalp")
			
			//--- Copying data files to Matlab Server ---
			sh "scp $data_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			sh "scp $eeg_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			sh "scp $leadfield_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			sh "scp $surface_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			sh "scp $scalp_file root@192.168.17.132:/root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
			
			//--- "Removing data files from Jenkins Server"
			sh "rm -f $JENKINS_HOME/workspace/BC-Vareta/$eeg"
			sh "rm -f $JENKINS_HOME/workspace/BC-Vareta/$leadfield"
			sh "rm -f $JENKINS_HOME/workspace/BC-Vareta/$surface"
			sh "rm -f $JENKINS_HOME/workspace/BC-Vareta/$scalp"
			sh "rm -f $JENKINS_HOME/workspace/BC-Vareta/task-config.xml"
			sh "rm -f $JENKINS_HOME/workspace/BC-Vareta/data.txt"
        }
    }
    
    //--- Run BC-Vareta stage ---
    stage('Data Processing (BC-Vareta)'){
        
        //--- Opening ssh connection with the Freesurfer server ---
        sshagent(['id_rsa_fsf']) { 
            
            //--- Run matlab function            
            echo "--- Run matlab scrip ---"
            sh "ssh root@192.168.17.132 bash /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/jenkins.sh"
        }
    }
    
    stage('Data delivery'){

        //--- Opening ssh connection with the Freesurfer server ---
        sshagent(['id_rsa_fsf']) { 
            
            //--- Tar and copy files result to FTP Server ---            
            sh "ssh root@192.168.17.132 tar fcz /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/$current_task.tar.gz --absolute-names /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results/"
            sh "ssh root@192.168.17.132 mv /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/$current_task.tar.gz /media/DATA/FTP/Matlab/BC-Vareta"
            
            //--- cleaning workspace and results folder ---
            sh "ssh root@192.168.17.132 rm -rf /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data/"
            sh "ssh root@192.168.17.132 mkdir /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data"
            sh "ssh root@192.168.17.132 rm -rf /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results"
            sh "ssh root@192.168.17.132 mkdir /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results"
        }
        
    }
    
    stage('Notification'){

       echo "Done!!!"
    }
}
