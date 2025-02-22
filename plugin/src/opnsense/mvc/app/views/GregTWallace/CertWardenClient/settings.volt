{{ partial("layout_partials/base_form",['fields':settingsForm,'id':'frm_Settings'])}}

<script type="text/javascript">
  $(document).ready(function () {
    // populate form
    mapDataToFormUI({
      frm_Settings: '/api/certwardenclient/settings/get',
    }).done(function (data) {});

    // save form and update config file
    $('#saveAct').click(function () {
      $('[id*="saveAct_progress"]').each(function(){
          $(this).addClass("fa fa-spinner fa-pulse");
      });

      saveFormToEndpoint(
        '/api/certwardenclient/settings/set',
        'frm_Settings',
        function () {
          // reload service
          ajaxCall(
            (url = '/api/certwardenclient/service/reload'),
            (sendData = {}),
            (callback = function (data, status) {
              // TODO: add a nice success message or something
              $('[id*="saveAct_progress"]').each(function(){
                    $(this).removeClass("fa fa-spinner fa-pulse");
              });
            })
          );
        }
      );
    });

    // test connection to Cert Warden
    $('#testConnAct').SimpleActionButton({
      onAction: function (data) {
        if (data['status'] == 'ok') {
          BootstrapDialog.show({
            type: BootstrapDialog.TYPE_INFO,
            title: "{{ lang._('Cert Warden Connectivity Result') }}",
            message: "{{ lang._('Cert Warden server responded as healthy.') }}",
            draggable: true,
          });
        }
      },
    });
  });
</script>

<div class="col-md-12">
  <button class="btn btn-primary" id="saveAct" type="button">
    <b>{{ lang._('Save') }}</b>
    <i id="saveAct_progress" class=""></i>
  </button>
  <button
    class="btn btn-primary"
    id="testConnAct"
    data-endpoint="/api/certwardenclient/service/connection_test"
    data-label="{{ lang._('Connection Test') }}"
  ></button>
</div>
