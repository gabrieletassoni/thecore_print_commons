module Abilities
    class ThecorePrintCommon
        include CanCan::Ability
        def initialize user
            cannot [:destroy, :create, :update, :show], [PrintJob]
            # if user
            #     cannot :edi
            #     # if the user is logged in, it can do certain tasks regardless his role
            #     if user.admin?
            #         # if the user is an admin, it can do a lot of things, usually
            #     end

            #     if user.has_role? :role
            #         # a specific role, brings specific powers
            #     end
            # end
        end
    end
end

# # include the extension
# TheCoreAbilities.send(:include, ThecorePrintCommonAbilitiesConcern)
