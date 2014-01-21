((function () {
    window.ActiveAdmin = {}, window.AA || (window.AA = window.ActiveAdmin)
})).call(this), function () {
    window.ActiveAdmin.CheckboxToggler = ActiveAdmin.CheckboxToggler = function () {
        function a(a, b) {
            var c;
            this.options = a, this.container = b, c = {}, this.options = $.extend({}, c, a), this._init(), this._bind()
        }

        return a.prototype._init = function () {
            if (!this.container)throw new Error("Container element not found");
            this.$container = $(this.container);
            if (!this.$container.find(".toggle_all").length)throw new Error('"toggle all" checkbox not found');
            return this.toggle_all_checkbox = this.$container.find(".toggle_all"), this.checkboxes = this.$container.find(":checkbox").not(this.toggle_all_checkbox)
        }, a.prototype._bind = function () {
            var a = this;
            return this.checkboxes.change(function (b) {
                return a._didChangeCheckbox(b.target)
            }), this.toggle_all_checkbox.change(function () {
                return a._didChangeToggleAllCheckbox()
            })
        }, a.prototype._didChangeCheckbox = function (a) {
            switch (this.checkboxes.filter(":checked").length) {
                case this.checkboxes.length - 1:
                    return this.toggle_all_checkbox.prop({checked: null});
                case this.checkboxes.length:
                    return this.toggle_all_checkbox.prop({checked: !0})
            }
        }, a.prototype._didChangeToggleAllCheckbox = function () {
            var a, b = this;
            return a = this.toggle_all_checkbox.prop("checked") ? !0 : null, this.checkboxes.each(function (c, d) {
                return $(d).prop({checked: a}), b._didChangeCheckbox(d)
            })
        }, a
    }(), jQuery(function (a) {
        return a.widget.bridge("checkboxToggler", ActiveAdmin.CheckboxToggler)
    })
}.call(this), function () {
    window.ActiveAdmin.DropdownMenu = ActiveAdmin.DropdownMenu = function () {
        function a(a, b) {
            var c;
            this.options = a, this.element = b, this.$element = $(this.element), c = {fadeInDuration: 20, fadeOutDuration: 100, onClickActionItemCallback: null}, this.options = $.extend({}, c, a), this.$menuButton = this.$element.find(".dropdown_menu_button"), this.$menuList = this.$element.find(".dropdown_menu_list_wrapper"), this.isOpen = !1, this._buildMenuList(), this._bind()
        }

        return a.prototype.open = function () {
            return this.isOpen = !0, this.$menuList.fadeIn(this.options.fadeInDuration), this._positionMenuList(), this._positionNipple(), this
        }, a.prototype.close = function () {
            return this.isOpen = !1, this.$menuList.fadeOut(this.options.fadeOutDuration), this
        }, a.prototype.destroy = function () {
            return this.$element.unbind(), this.$element = null, this
        }, a.prototype.isDisabled = function () {
            return this.$menuButton.hasClass("disabled")
        }, a.prototype.disable = function () {
            return this.$menuButton.addClass("disabled")
        }, a.prototype.enable = function () {
            return this.$menuButton.removeClass("disabled")
        }, a.prototype.option = function (a, b) {
            return $.isPlainObject(a) ? this.options = $.extend(!0, this.options, a) : a != null ? this.options[a] : this.options[a] = b
        }, a.prototype._buildMenuList = function () {
            return this.$menuList.prepend('<div class="dropdown_menu_nipple"></div>'), this.$menuList.hide()
        }, a.prototype._bind = function () {
            var a = this;
            return $("body").bind("click", function () {
                if (a.isOpen === !0)return a.close()
            }), this.$menuButton.bind("click", function () {
                return a.isDisabled() || (a.isOpen === !0 ? a.close() : a.open()), !1
            })
        }, a.prototype._positionMenuList = function () {
            var a, b, c;
            return a = this.$menuButton.position().left + this.$menuButton.outerWidth() / 2, b = this.$menuList.outerWidth() / 2, c = a - b, this.$menuList.css("left", c)
        }, a.prototype._positionNipple = function () {
            var a, b, c, d, e;
            return c = this.$menuList.outerWidth() / 2, b = this.$menuButton.position().top + this.$menuButton.outerHeight() + 10, this.$menuList.css("top", b), a = this.$menuList.find(".dropdown_menu_nipple"), d = a.outerWidth() / 2, e = c - d, a.css("left", e)
        }, a
    }(), function (a) {
        return a.widget.bridge("aaDropdownMenu", ActiveAdmin.DropdownMenu), a(function () {
            return a(".dropdown_menu").aaDropdownMenu()
        })
    }(jQuery)
}.call(this), function () {
    window.ActiveAdmin.Popover = ActiveAdmin.Popover = function () {
        function a(a, b) {
            var c;
            this.options = a, this.element = b, this.$element = $(this.element), c = {fadeInDuration: 20, fadeOutDuration: 100, autoOpen: !0, pageWrapperElement: "#wrapper", onClickActionItemCallback: null}, this.options = $.extend({}, c, a), this.$popover = null, this.isOpen = !1, $(this.$element.attr("href")).length > 0 ? this.$popover = $(this.$element.attr("href")) : this.$popover = this.$element.next(".popover"), this._buildPopover(), this._bind()
        }

        return a.prototype.open = function () {
            return this.isOpen = !0, this.$popover.fadeIn(this.options.fadeInDuration), this._positionPopover(), this._positionNipple(), this
        }, a.prototype.close = function () {
            return this.isOpen = !1, this.$popover.fadeOut(this.options.fadeOutDuration), this
        }, a.prototype.destroy = function () {
            return this.$element.removeData("popover"), this.$element.unbind(), this.$element = null, this
        }, a.prototype.option = function () {
        }, a.prototype._buildPopover = function () {
            return this.$popover.prepend('<div class="popover_nipple"></div>'), this.$popover.hide(), this.$popover.addClass("popover")
        }, a.prototype._bind = function () {
            var a = this;
            $(this.options.pageWrapperElement).bind("click", function (b) {
                if (a.isOpen === !0)return a.close()
            });
            if (this.options.autoOpen === !0)return this.$element.bind("click", function () {
                return a.isOpen === !0 ? a.close() : a.open(), !1
            })
        }, a.prototype._positionPopover = function () {
            var a, b, c;
            return a = this.$element.offset().left + this.$element.outerWidth() / 2, b = this.$popover.outerWidth() / 2, c = a - b, this.$popover.css("left", c)
        }, a.prototype._positionNipple = function () {
            var a, b, c, d, e;
            return c = this.$popover.outerWidth() / 2, b = this.$element.offset().top + this.$element.outerHeight() + 10, this.$popover.css("top", b), a = this.$popover.find(".popover_nipple"), d = a.outerWidth() / 2, e = c - d, a.css("left", e)
        }, a
    }(), function (a) {
        return a.widget.bridge("popover", ActiveAdmin.Popover)
    }(jQuery)
}.call(this), function () {
    var a, b = {}.hasOwnProperty, c = function (a, c) {
        function e() {
            this.constructor = a
        }

        for (var d in c)b.call(c, d) && (a[d] = c[d]);
        return e.prototype = c.prototype, a.prototype = new e, a.__super__ = c.prototype, a
    };
    window.ActiveAdmin.TableCheckboxToggler = ActiveAdmin.TableCheckboxToggler = function (b) {
        function d() {
            return a = d.__super__.constructor.apply(this, arguments), a
        }

        return c(d, b), d.prototype._init = function () {
            return d.__super__._init.apply(this, arguments)
        }, d.prototype._bind = function () {
            var a = this;
            return d.__super__._bind.apply(this, arguments), this.$container.find("tbody td").click(function (b) {
                if (b.target.type !== "checkbox")return a._didClickCell(b.target)
            })
        }, d.prototype._didChangeCheckbox = function (a) {
            var b;
            return d.__super__._didChangeCheckbox.apply(this, arguments), b = $(a).parents("tr"), a.checked ? b.addClass("selected") : b.removeClass("selected")
        }, d.prototype._didClickCell = function (a) {
            return $(a).parent("tr").find(":checkbox").click()
        }, d
    }(ActiveAdmin.CheckboxToggler), jQuery(function (a) {
        return a.widget.bridge("tableCheckboxToggler", ActiveAdmin.TableCheckboxToggler)
    })
}.call(this), function () {
    $(function () {
        return $(document).on("focus", ".datepicker:not(.hasDatepicker)", function () {
            return $(this).datepicker({dateFormat: "yy-mm-dd"})
        }), $(".clear_filters_btn").click(function () {
            return window.location.search = ""
        }), $(".dropdown_button").popover(), $(".filter_form").submit(function () {
            return $(this).find(":input").filter(function () {
                return this.value === ""
            }).prop("disabled", !0)
        }), $(".filter_form_field.select_and_search select").change(function () {
            return $(this).siblings("input").prop({name: "q[" + this.value + "]"})
        })
    })
}.call(this), function () {
    jQuery(function (a) {
        a(document).delegate("#batch_actions_selector li a", "click.rails", function () {
            return a("#batch_action").val(a(this).attr("data-action")), a("#collection_selection").submit()
        });
        if (a("#batch_actions_selector").length && a(":checkbox.toggle_all").length)return a(".paginated_collection table.index_table").length ? a(".paginated_collection table.index_table").tableCheckboxToggler() : a(".paginated_collection").checkboxToggler(), a(".paginated_collection").find(":checkbox").bind("change", function () {
            return a(".paginated_collection").find(":checkbox").filter(":checked").length > 0 ? a("#batch_actions_selector").aaDropdownMenu("enable") : a("#batch_actions_selector").aaDropdownMenu("disable")
        })
    })
}.call(this);