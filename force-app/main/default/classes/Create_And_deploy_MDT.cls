public with sharing class Create_And_deploy_MDT implements Metadata.DeployCallback{
    public void handleResult(Metadata.DeployResult result, Metadata.DeployCallbackContext context) {
        if (result.status == Metadata.DeployStatus.Succeeded) {
            System.debug(' success : '+ result);
        } else {
            System.debug(' fail : '+ result);
        }
    }
	@future
    public static void createUpdateMetadata(String fullName, String label, String metaMap){
        Metadata.CustomMetadata customMetadata =  new Metadata.CustomMetadata();
        customMetadata.fullName = fullName;
        customMetadata.label = label;
        Map<String, Object> fieldWithValuesMap = (Map<String, Object> )JSON.deserialize(metamap, Map<String, Object>.class);
        for(String key : fieldWithValuesMap.keySet()){
            Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
            customField.field = key;
            customField.value = fieldWithValuesMap.get(key); 
            customMetadata.values.add(customField);
        }
        
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        mdContainer.addMetadata(customMetadata);
        Create_And_deploy_MDT callback = new Create_And_deploy_MDT();
        Id jobId = Metadata.Operations.enqueueDeployment(mdContainer, callback);
    }
}