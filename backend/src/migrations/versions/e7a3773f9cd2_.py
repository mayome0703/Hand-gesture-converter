"""empty message

Revision ID: e7a3773f9cd2
Revises: 
Create Date: 2024-09-08 02:10:24.458820

"""
from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision = 'e7a3773f9cd2'
down_revision = None
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_table('sign_parameters',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('sign', sa.String(), nullable=False),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('id')
    )
    op.create_table('accelerometer',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('acc_min', sa.Float(), nullable=True),
    sa.Column('acc_max', sa.Float(), nullable=True),
    sa.Column('sign_parameters_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['sign_parameters_id'], ['sign_parameters.id'], ),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('id')
    )
    op.create_table('flex_sensor',
    sa.Column('id', sa.Integer(), nullable=False),
    sa.Column('flex_min', sa.Float(), nullable=True),
    sa.Column('flex_max', sa.Float(), nullable=True),
    sa.Column('sign_parameters_id', sa.Integer(), nullable=True),
    sa.ForeignKeyConstraint(['sign_parameters_id'], ['sign_parameters.id'], ),
    sa.PrimaryKeyConstraint('id'),
    sa.UniqueConstraint('id')
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_table('flex_sensor')
    op.drop_table('accelerometer')
    op.drop_table('sign_parameters')
    # ### end Alembic commands ###
