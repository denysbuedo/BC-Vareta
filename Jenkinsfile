/*
@Autor: Denys Buedo Hidalgo
@Proyecto: BC-Bareta
@Joint China-Cuba Laboratory
@Universidad de las Ciencias Informáticas
*/

node {
    
    //--- load new task data ---
	echo "Reading the task data"
    def data = readFile "$JENKINS_HOME/workspace/BC-Vareta/data.xml"
	def parser = new XmlParser().parseText(data)
	def eeg = "${parser.attribute("EEG")}"
	def leadfield ="${parser.attribute("LeadField")}"
    def surface ="${parser.attribute("Surface")}"
	def scalp="${parser.attribute("Scalp")}"
	 
	//--- Setting Build description ---
	currentBuild.displayName = "BC-Vareta_dbuedo"
    
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
			sh "rm -f $JENKINS_HOME/workspace/BC-Vareta/data.xml"
			sh "rm -f $JENKINS_HOME/workspace/BC-Vareta/data.txt"
        }
    }
    
    //--- Run BC-Vareta stage ---
    stage('Data Processing (BC-Vareta)'){
        
        //--- Opening ssh connection with the Freesurfer server ---
        sshagent(['id_rsa_fsf']) { 
            
            //--- Run matlab function            
            echo "--- Run matlab scrip ---"
            sh "ssh root@192.168.17.132 chmod +x /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/jenkins.sh"
            sh "ssh root@192.168.17.132 bash /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/jenkins.sh"
        }
    }
    
    stage('Data delivery'){

        //--- Opening ssh connection with the Freesurfer server ---
        sshagent(['id_rsa_fsf']) { 
            
            //--- Tar and copy files result to FTP Server ---            
            sh "ssh root@192.168.17.132 tar fcz /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results-dbuedo.tar.gz --absolute-names /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results/"
            sh "ssh root@192.168.17.132 mv /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results-dbuedo.tar.gz /media/DATA/FTP/Matlab/BC-Vareta"
            
            //--- cleaning workspace and results folder ---
            ssh "ssh root@192.168.17.132 rm -rf /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data"
            ssh "ssh root@192.168.17.132 mkdir /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/External_data"
            ssh "ssh root@192.168.17.132 rm -rf /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results"
            ssh "ssh root@192.168.17.132 mkdir /root/matlab/BC-VARETA-toolbox-master/BC-VARETA-toolbox-master/results"
        }
        
    }
    
    stage('Notification'){

        //TODO Notification stage
    }
}