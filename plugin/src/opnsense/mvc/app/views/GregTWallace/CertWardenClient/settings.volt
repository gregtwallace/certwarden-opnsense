{{ partial("layout_partials/base_form",['fields':settingsForm,'id':'frm_Settings'])}}

<script type="text/javascript">
  // Borrow some Core code
  function reloadWaitNew () {
      $.ajax({
          url: '/ui/certwardenclient/',
          timeout: 1250
      }).fail(function () {
          setTimeout(reloadWaitOld, 1250);
      }).done(function () {
          window.location.assign('/ui/certwardenclient/');
      });
  }
  function reloadWaitOld () {
      $.ajax({
          url: '/ui/certwardenclient/',
          timeout: 1250
      }).fail(function () {
          setTimeout(reloadWaitNew, 1250);
      }).done(function () {
          window.location.assign('/ui/certwardenclient/');
      });
  }
  // end Core code

  $(document).ready(function () {
    // populate form
    mapDataToFormUI({
      frm_Settings: '/api/certwardenclient/settings/get',
    }).done(function (data) {});

    // save form and update config file
    $('#saveAct').click(function () {
      $('[id*="saveAct_progress"]').each(function () {
        $(this).addClass('fa fa-spinner fa-pulse');
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
            })
          );
        }
      );

      $('[id*="saveAct_progress"]').each(function () {
        $(this).removeClass('fa fa-spinner fa-pulse');
      });
    });

    // update Certificate in Trust Store
    $('#updateCertAct').SimpleActionButton({
      onAction: function (data) {
        if (data['status'] == 'ok') {
          $canClose = true;
          $messageStr = "{{ lang._('Cert Warden certificate already up to date.')}}";
          $onShowFunc = function(dialogReg){};
          if (!data['cert_found'] || data['cert_updated']) {
            if (data['web_ui_restart']) {
              $canClose = false;
              $messageStr = `{{ lang._('Cert Warden certificate was successfully updated.
                \n\n
                The web GUI is reloading, please wait...
                \n\n
                If the page does not reload %sclick here%s.
                ') | format('<a href="/ui/certwardenclient/">','</a>') }}`;
              $onShowFunc = function (dialogRef) {
                setTimeout(reloadWaitNew, 20000);
              };
            } else {
              $messageStr = "{{ lang._('Cert Warden certificate updated.')}}";
            }
          }

          BootstrapDialog.show({
            type: BootstrapDialog.TYPE_INFO,
            title: "{{ lang._('Cert Warden Client') }}",
            closable: $canClose,
            message: $messageStr,
            onshow: $onShowFunc,
          });
        }
      },
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

    // unlink the Cert Warden cert from the Trust Store (so it can be deleted)
    $('#unlinkCertAct').SimpleActionButton({
      onAction: function (data) {
        if (data['status'] == 'ok') {
          BootstrapDialog.show({
            type: BootstrapDialog.TYPE_INFO,
            title: "{{ lang._('Cert Warden Cert Unlink') }}",
            message: "{{ lang._('Cert Warden is no longer linked to the certificate in the Trust Store.') }}",
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
    id="updateCertAct"
    data-endpoint="/api/certwardenclient/service/update_cert"
    data-label="{{ lang._('Update Cert') }}"
  ></button>

  <button
    class="btn btn-secondary"
    id="testConnAct"
    data-endpoint="/api/certwardenclient/service/connection_test"
    data-label="{{ lang._('Connection Test') }}"
  ></button>

  <button
    class="btn btn-secondary"
    id="unlinkCertAct"
    data-endpoint="/api/certwardenclient/settings/unlink_cert"
    data-label="{{ lang._('Unlink Certificate') }}"
  >
    <i id="unlinkCertAct_progress" class=""></i>
  </button>
</div>
