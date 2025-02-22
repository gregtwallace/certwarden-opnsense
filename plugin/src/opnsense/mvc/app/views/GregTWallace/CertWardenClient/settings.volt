{{ partial("layout_partials/base_form",['fields':settingsForm,'id':'frm_Settings'])}}

<script type="text/javascript">
  $( document ).ready(function() {
      // populate form
      mapDataToFormUI({'frm_Settings':"/api/certwardenclient/settings/get"}).done(function(data){
      });

      // save form and update config file
      $("#saveAct").click(function(){
          saveFormToEndpoint("/api/certwardenclient/settings/set",'frm_Settings',function(){
              // reload service
              ajaxCall(url="/api/certwardenclient/service/reload", sendData={},callback=function(data,status) {
                  // TODO: add a nice success message or something
                  window.location.reload(true);
              });
          });
      });
  });
</script>

<div class="col-md-12">
  <button class="btn btn-primary"  id="saveAct" type="button"><b>{{ lang._('Save') }}</b></button>
</div>
