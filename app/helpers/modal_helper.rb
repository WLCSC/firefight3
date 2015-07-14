module ModalHelper
  def modal id, title, &block
    (<<-eos
    <div class="modal fade" id="#{id}" tabindex="-1" role="dialog">
      <div class="modal-dialog" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">#{title}</h4>
          </div>
          <div class="modal-body">
            #{capture(&block)}
          </div>
        </div>
      </div>
    </div>
    eos
    ).html_safe
  end
end
