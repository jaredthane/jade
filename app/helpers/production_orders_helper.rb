module ProductionOrdersHelper
	def current_status(order)
		return 'Terminado' if order.finished_at
		return 'Iniciado' if order.started_at
		return 'Planeado'
	end
	def last_timestamp(order)
		return order.finished_at if order.finished_at
		return order.started_at if order.started_at
		return order.created_at
	end
	def last_person(order)
		return order.finished_by if order.finished_at
		return order.started_by if order.started_at
		return order.created_by
	end
end
