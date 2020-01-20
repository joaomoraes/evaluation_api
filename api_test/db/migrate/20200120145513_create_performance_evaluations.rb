class CreatePerformanceEvaluations < ActiveRecord::Migration[5.2]
  def change
    create_table :performance_evaluations do |t|
      t.references :evaluator, foreign_key: { to_table: :users }, null: false
      t.references :target, foreign_key: { to_table: :users }, null: false
      t.text :description, null: false

      t.timestamps
    end
  end
end
